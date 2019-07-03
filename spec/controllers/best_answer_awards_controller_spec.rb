class BestAnswerAwardsController < ApplicationController
  def index
    @best_answer_awards = current_user.best_answer_awards.with_attached_image
  end
end
