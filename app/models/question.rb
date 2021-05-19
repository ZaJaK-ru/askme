class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true
  has_and_belongs_to_many :hashtags

  validates :text, presence: true
  validates :text, length: { maximum: 255 }

  after_commit :update_hashtags, on: [:create, :update]

  before_destroy :delete_hashtag

  private

  def update_hashtags
    question = Question.find_by(id: self.id)
    question.hashtags.clear
    hashtags = "#{text} #{answer}".scan(/#[[:alpha:]]+/)
    hashtags.uniq.map do |tag|
      hashtag = Hashtag.find_or_create_by(name: tag.downcase.delete('#'))
      question.hashtags << hashtag
    end
  end

  def delete_hashtag
    hashtags.each { |hashtag| hashtag.destroy }
  end
end
