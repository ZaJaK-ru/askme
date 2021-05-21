class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true
  has_many :question_hashtag, dependent: :destroy
  has_many :hashtags, through: :question_hashtag

  validates :text, presence: true
  validates :text, length: { maximum: 255 }

  after_save_commit :update_hashtags

  before_destroy :delete_hashtags

  private

  def update_hashtags
    self.hashtags = "#{text} #{answer}".scan(/#[[:alpha:]]+/).uniq.map do |tag|
      Hashtag.find_or_create_by(name: tag.downcase.delete('#'))
    end
  end

  def delete_hashtags
    hashtags.each { |hashtag| hashtag.destroy }
  end
end
