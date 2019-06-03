class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def mark_as_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
