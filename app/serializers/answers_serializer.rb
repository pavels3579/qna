class AnswersSerializer < ActiveModel::Serializer
  has_many :links
  has_many :comments
  belongs_to :author, class_name: 'User'

  attributes :id, :body, :question_id, :created_at, :updated_at
end
