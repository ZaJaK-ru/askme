require 'openssl'

class User < ApplicationRecord
  ITERATION = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  VALID_USERNAME_REGEX = /\A\w+\z/

  has_many :questions

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true

  attr_accessor :password

  validates :email, email: true
  validates :username, length: { maximum: 40 }, format: { with: VALID_USERNAME_REGEX }

  validates :password, presence: true, on: :create
  validates :password, confirmation: true

  before_validation :normalize_username

  before_save :encrypt_password

  def normalize_username
    self.username.downcase!
  end

  def encrypt_password
    if self.password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          self.password, self.password_salt, ITERATION, DIGEST.length, DIGEST
        )
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    if user.present? && user.password_hash == User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATION, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end

end
