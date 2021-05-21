class Hashtag < ApplicationRecord
  has_many :question_hashtag, dependent: :destroy
  has_many :questions, through: :question_hashtag
end
