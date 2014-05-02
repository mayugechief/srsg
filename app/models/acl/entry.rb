# coding: utf-8
class Acl::Entry
  extend SS::Translation
  include SS::Document
  include SS::References::Site
  
  seqid :id
  belongs_to :user, class_name: "SS::User"
  field :permits, type: Array
  permit_params :user_id, permits: []
  cattr_accessor :permit_options

  validates :user_id, uniqueness: {scope: :site_id}, presence: true

  public
    def permit_names
      names = []
      self.permits.each do |permit|
        Acl::Entry.selectable_permits.each do |opt|
          names << opt[:name] if permit == opt[:_id]
        end
      end
      return names
    end
  
  class << self
    def selectable_permits
      options = []
      permit_options.each do |_id|
         name = I18n.translate _id.singularize, scope: [:modules, :permits], default: _id.titleize
         options << { _id: _id, name: name }
       end
       options
    end
  end
end
