# coding: utf-8
class SS::Group
  include SS::Document
  
  seqid :id
  field :name, type: String

  scope :site, ->(site) { where name:  /^#{site.group.name}\// }
  scope :root, ->(group) { where name:  /^#{group.name.split('/')[0]}$/ }
  
  permit_params :name
  
  validates :name, presence: true, length: { maximum: 80 }

  public
    def root_name
      self.name.split('/')[0]
    end
  
    def root_groups
      SS::Group.where name: /^[^\/]*$/
    end
  
    def root_options
     self.root_groups.map do |g|
       [ g.name, g.id ]
      end
    end
end
