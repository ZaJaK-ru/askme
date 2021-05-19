class HashtagsController < ApplicationController
  def show
    @hashtag = Hashtag.find_by!(id: params[:id])
    @questions = @hashtag.questions

    redirect_to root_path, alert: "Нет таких вопросов!" if @questions.blank?
  end
end
