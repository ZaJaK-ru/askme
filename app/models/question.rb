class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true
  has_many :hashtag_questions, dependent: :destroy
  has_many :hashtags, through: :hashtag_questions

  validates :text, presence: true
  validates :text, length: { maximum: 255 }

  after_save_commit :update_hashtags

  private

  def update_hashtags
    self.hashtags = "#{text} #{answer}".scan(Hashtag::HASHTAG_REGEXP).uniq.map do |tag|
      Hashtag.find_or_create_by(name: tag.downcase.delete('#'))
    end
  end
end
