require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  VALID_USERNAME_REGEX = /\A\w+\z/

  attr_accessor :password

  has_many :questions, dependent: :destroy
  has_many :asked_questions, class_name: 'Question', foreign_key: :author_id, dependent: :nullify

  before_validation :normalize_username_and_email

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true

  validates :email, email: true
  validates :username, length: { maximum: 40 }, format: { with: VALID_USERNAME_REGEX }

  validates :password, presence: true, on: :create
  validates :password, confirmation: true

  validates :bgcolor, format: { with /\A#\h{6}\z/ }

  before_save :encrypt_password

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    return nil unless user.present?

    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    return user if user.password_hash == hashed_password

    nil
  end

  private

  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )
    end
  end

  def normalize_username_and_email
    username&.downcase!
    email&.downcase!
  end
end
