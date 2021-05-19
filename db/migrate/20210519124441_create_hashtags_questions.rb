class CreateHashtagsQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :hashtags_questions, :id => false do |t|
      t.references :hashtag, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
    end
  end
end
