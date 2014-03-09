# coding: utf-8
module SS::References
  module Site
    extend ActiveSupport::Concern
    
    included do
      belongs_to :site, class_name: "SS::Site"
      scope :site, ->(site) { where(site_id: site._id) }
    end
  end
end
