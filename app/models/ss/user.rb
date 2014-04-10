# coding: utf-8
class SS::User
  include SS::Document
  include SS::Permission
  
  seqid :id
  field :name, type: String
  field :email, type: String, metadata: { form: :email }
  field :password, type: String
  
  embeds_ids :groups, class_name: "SS::Group"
  
  permit_params :name, :email, :password, group_ids: []
  
  index({ email: 1 }, { unique: true })
  
  validates :name, presence: true, length: { maximum: 40 }
  validates :email, uniqueness: true, presence: true, email: true, length: { maximum: 80 }
  validates :password, presence: true
  
  before_save :encrypt_password
  
  def encrypt_password
    self.password = SS::Crypt.crypt(password) if password_changed?
  end
  
  def has_permit?(targets = {})
    targets.each do |name, item|
      return false unless item.permitted?(name => self)
    end
    true
  end
end
