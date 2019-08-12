module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_parent_resource, only: %i[vote_up vote_down]
  end

  def vote_up
    vote(:vote_up)
  end

  def vote_down
    vote(:vote_down)
  end

  private

  def vote(choice)
    authorize! :vote, @parent_resource

    @parent_resource.send(choice, current_user)
    render json: {
      resourceName: @parent_resource.class.name.downcase,
      resourceId: @parent_resource.id,
      resourceScore: @parent_resource.vote_sum
    }
  end

  def set_parent_resource
    @parent_resource = controller_to_klass.find(params[:id])
  end

  def controller_to_klass
    controller_name.classify.constantize
  end
end
