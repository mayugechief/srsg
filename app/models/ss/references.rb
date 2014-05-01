# coding: utf-8
module SS::References
  module Site
    extend ActiveSupport::Concern
    
    included do
      scope :site, ->(site) { where(site_id: site._id) }
      
      belongs_to :site, class_name: "SS::Site"
    end
  end
end
