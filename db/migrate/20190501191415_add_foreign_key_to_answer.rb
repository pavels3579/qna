class AddForeignKeyToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :answers, :questions, column: :question_id
  end
end
