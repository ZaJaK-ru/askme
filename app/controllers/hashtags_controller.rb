class HashtagsController < ApplicationController
  def show
    @hashtag = Hashtag.only_uniq.find_by!(name: params[:name])
    @questions = @hashtag.questions
  end
end
