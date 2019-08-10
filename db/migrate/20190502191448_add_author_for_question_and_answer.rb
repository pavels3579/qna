class AddAuthorForQuestionAndAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column(:questions, :author_id, :integer)
    add_column(:answers, :author_id, :integer)

    add_foreign_key :questions, :users, column: :author_id
    add_foreign_key :answers, :users, column: :author_id

    add_index(:questions, :author_id)
    add_index(:answers, :author_id)
  end
end
