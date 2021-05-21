class CreateQuestionHashtags < ActiveRecord::Migration[6.1]
  def change
    create_table :question_hashtags do |t|
      t.references :question, null: false, foreign_key: true
      t.references :hashtag, null: false, foreign_key: true
    end
  end
end
