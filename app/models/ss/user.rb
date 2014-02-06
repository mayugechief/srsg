# coding: utf-8
class SS::User
  include SS::Document
  
  seqid :id
  field :name, type: String
  field :email, type: String, metadata: { form: :email }
  field :password, type: String
  
  embeds_ids :groups, class_name: "SS::Group"
  
  index({ email: 1 }, { unique: true })
  
  validates :name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, email: true, length: { maximum: 80 }
  validates :password, presence: true
  
  before_save :encrypt_password
  
  def encrypt_password
    self.password = SS::Crypt.crypt(password) if password_changed?
  end
end
