# coding: utf-8
class SS::User
  include SS::Document
  include SS::Permission
  
  index({ email: 1 }, { unique: true })
  
  seqid :id
  field :name, type: String
  field :email, type: String, metadata: { form: :email }
  field :password, type: String
  
  embeds_ids :groups, class_name: "SS::Group"
  
  permit_params :name, :email, :password, group_ids: []
  
  validates :name, presence: true, length: { maximum: 40 }
  validates :email, uniqueness: true, presence: true, email: true, length: { maximum: 80 }
  validates :password, presence: true
  
  before_save :encrypt_password
  
  def encrypt_password
    self.password = SS::Crypt.crypt(password) if password_changed?
  end

  def root_groups
    names = []
    self.groups.each do |group|
        names << group.root_name
    end
    SS::Group.where(:name.in => names)
  end
  
  def root_group_ids
    self.root_groups.map{|group| group.id}
  end
  
  def my_site?(site)
    return true if self.has_permit?(permits: :master)
    self.root_group_ids.index(site.group_id)
  end
  
  def has_permit?(targets = {})
    return super if defined?(super)
    
    targets.each do |name, item|
      return false unless item.permitted?(name => self)
    end
    true
  end
end
