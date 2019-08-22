class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :files
  has_many :links
  has_many :comments
  belongs_to :author, class_name: 'User'

  def files
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
  end
end
