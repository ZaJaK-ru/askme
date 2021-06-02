module QuestionsHelper
  def hashtag_link(hashtag)
    link_to hashtag, hashtag_path(hashtag.downcase.delete('#'))
  end

  def render_with_hashtags(text)
    text.gsub(Hashtag::HASHTAG_REGEXP) { |hashtag| hashtag_link(hashtag) }.html_safe
  end
end
