class User < ApplicationRecord
  has_many :questions, foreign_key: "author_id", dependent: :destroy
  has_many :answers, foreign_key: "author_id", dependent: :destroy
  has_many :best_answer_awards, dependent: :delete_all

  has_many :votes, dependent: :delete_all
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def its_author?(resource)
    id == resource.author_id
  end
end
