class Question < ApplicationRecord
  include Votable

  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :best_answer_award, dependent: :destroy

  belongs_to :author, class_name: 'User'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :best_answer_award, reject_if: :all_blank

  validates :title, :body, presence:true
end
