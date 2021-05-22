class Hashtag < ApplicationRecord
  HASHTAG_REGEXP = /#[[:alpha:]]+/.freeze

  has_many :hashtag_questions, dependent: :destroy
  has_many :questions, through: :hashtag_questions

  def self.only_uniq
    joins(:questions).uniq
  end
end
