class SubscriptionsController < ApplicationController

  skip_authorization_check

  before_action :authenticate_user!
  before_action :load_question

  def create
    return head :forbidden if current_user.subscribed_to?(@question)

    @subscription = @question.subscriptions.new
    @subscription.user = current_user
    @subscription.save
  end

  def destroy
    return head :forbidden unless current_user.subscribed_to?(@question)

    subscription = @question.subscriptions.find_by(user: current_user)
    subscription.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id]) || Question.find(params[:id])
  end
end
