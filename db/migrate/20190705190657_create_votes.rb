class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.belongs_to :votable, polymorphic: true
      t.references :user, foreign_key: true
      t.integer :score, default: 0, null: false

      t.timestamps
    end
  end
end
