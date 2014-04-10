# coding: utf-8
module SS::Permission
  extend ActiveSupport::Concern
  
  def permitted?(targets = {})
    return super if defined?(super)
    
    targets.each do |name, user|
      return unless user
    end
    true
  end
end
