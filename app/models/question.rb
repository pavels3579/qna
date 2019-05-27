class Question < ApplicationRecord
  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :title, :body, presence:true
end
