class CommentsController < ApplicationController
  before_action :set_parent_resource, only: :create
  before_action :authenticate_user!, only: %i[create]
  after_action :publish_comment, only: %i[create]

  authorize_resource

  def create
    @comment = @parent_resource.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_parent_resource
    data = parent_resource_params
    @parent_resource = data[:klass].find(data[:id])
  end

  def parent_resource_params
    klass = params['question_id'].nil? ? Answer : Question
    id = params["#{klass.to_s.downcase}_id"]
    { id: id, klass: klass }
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    data = parent_resource_params
    question_id = data[:klass] == Question ? data[:id] : Answer.find(data[:id]).question_id

    ActionCable.server.broadcast(
      "questions/#{question_id}/comments", comment: @comment
    )
  end
end
