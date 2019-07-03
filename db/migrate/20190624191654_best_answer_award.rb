class BestAnswerAward < ActiveRecord::Migration[5.2]
  def change
    create_table :best_answer_awards do |t|
      t.string :title
      t.references :question, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
