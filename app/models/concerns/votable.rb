module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  def sum
    votes.sum(:score)
  end

  def vote_allowed?(user, score)
    find_previous_vote(user)&.score != score
  end

  private

  def find_previous_vote(user)
    votes.find_by(user: user.id)
  end

  def vote(user, score)
    return false if user.its_author?(self) || !vote_allowed?(user, score)

    transaction do
      find_previous_vote(user)&.destroy
      votes.create(user: user, score: score)
    end
  end
end
