class BestAnswerAwardsController < ApplicationController
  skip_authorization_check

  def index
    @best_answer_awards = current_user.best_answer_awards.with_attached_image
  end
end
