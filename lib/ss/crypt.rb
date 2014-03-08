# coding: utf-8
require 'digest/md5'
require 'openssl'
require 'base64'
module SS::Crypt
  class << self
    def crypt(str, salt = "srsg")
      Digest::MD5.hexdigest(Digest::MD5.digest(str) + salt)
    end
    
    def encrypt(str, opt = {})
      opt = { pass: "srsg", salt: nil, type: "AES-256-CBC" }.merge(opt)
      cipher = OpenSSL::Cipher::Cipher.new opt[:type]
      cipher.encrypt
      cipher.pkcs5_keyivgen opt[:pass], opt[:salt]
      Base64.encode64(cipher.update(str) + cipher.final) rescue nil
    end
    
    def decrypt(str, opt = {})
      opt = { pass: "srsg", salt: nil, type: "AES-256-CBC" }.merge(opt)
      cipher = OpenSSL::Cipher::Cipher.new opt[:type]
      cipher.decrypt
      cipher.pkcs5_keyivgen opt[:pass]#, opt[:salt]
      cipher.update(Base64.decode64(str)) + cipher.final rescue nil
    end
  end
end
