# coding: utf-8
module Acl::Addons
  module Owners
    extend ActiveSupport::Concern
    extend SS::Addon
    
    included do
      embeds_ids :owner_groups, class_name: "SS::Group"
      permit_params owner_group_ids: []
      cattr_accessor :acl_entry_name
    end
    
    public
      def owner?(user)
        self.owner_group_ids.each do |group_id|
          return true if user.group_ids.index(group_id)
        end
        false
      end
      
      def owner_group_names
        names = []
        return names if self.owner_group_ids.blank?
        SS::Group.any_in(_id: self.owner_group_ids).each do |group|
          names << group.name
        end
        names
      end
      
      def permitted?(opt={})
        opt[:site] = self.site unless opt[:site]
        opt[:action] = :read unless opt[:action]
        
        return false unless opt[:user]
        return true if opt[:user].has_permit?(site: opt[:site],permits: :admin)
        
        permits = []
        if self.id > 0
          if self.owner?(opt[:user])
            return true if opt[:action] == :read
            permits = self.trans_permits(opt[:action], :private)
          else
            permits = self.trans_permits(opt[:action])
          end
        else
            permits = self.trans_permits(opt[:action], :private)
        end
        opt[:user].has_permit?(site: opt[:site],permits:  permits)
      end
      
      def trans_permits(action, arg=nil)
        permits = []
        
        if action.to_s.index("_")
          str = action.to_s
        elsif self.acl_entry_name
          str = action.to_s + "_" + self.acl_entry_name
        else
          str = action.to_s
        end
        permits << str.to_sym
        
        s = str.split("_")
        case s[0].to_sym
        when :create, :update, :delete, :read, :config
          permits << str.gsub(s[0], s[0] + "_private").to_sym if arg == :private
          permits << str.gsub(s[0], "manage").to_sym
          permits << str.gsub(s[0], "manage_private").to_sym if arg == :private
        when :manage
          permits << str.gsub(s[0], s[0] + "_private").to_sym if arg == :private
        end
        
        return permits
      end
      
    module ClassMethods
      def where_permitted(opt={})
        if opt[:user].blank? || opt[:site].blank?
          return self.where(owner_group_ids: -1)
        end
        
        return self.all() if opt[:user].has_permit?(site: opt[:site], permits: :admin)
        self.where(:owner_group_ids.in => opt[:user].group_ids )
      end
    end
  end
  
  module Entries
    extend ActiveSupport::Concern
    
    public
      def has_permit?(opt={})
        return true if Acl::Entry.where(user_id: self.id).
          where(site_id: 0).where(:permits.in => [:master]).count > 0
        
        return unless opt[:site]
        return unless opt[:permits]
        
        if Symbol === opt[:permits]
          permits = [opt[:permits]]
        else
          permits = opt[:permits]
        end 
        permits = permits.flatten
        
        @acl_entries = Acl::Entry.site(opt[:site]).where(user_id: self.id) if @acl_entries.blank?
        @acl_entries.each do |entry|
          entry.permits.each do |permit|
            return true unless permits.index(permit.to_sym).nil?
          end
        end
        
        false
      end
  end
end
