require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let!(:user) { create :user }
    let(:another_user) { create :user }
    let(:question) { create :question, author: user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, author: user) }
    it { should_not be_able_to :update, create(:question, author: another_user) }

    it { should be_able_to :update, create(:answer, author: user, question: question) }
    it { should_not be_able_to :update, create(:answer, author: another_user, question: question) }

    it { should be_able_to :destroy, create(:question, author: user) }
    it { should_not be_able_to :destroy, create(:question, author: another_user) }

    it { should be_able_to :destroy, create(:answer, author: user, question: question) }
    it { should_not be_able_to :destroy, create(:answer, author: another_user, question: question) }

    it { should_not be_able_to :vote, create(:question, author: user) }
    it { should be_able_to :vote, create(:question, author: another_user) }

    it { should_not be_able_to :vote, create(:answer, author: user, question: question) }
    it { should be_able_to :vote, create(:answer, author: another_user, question: question) }
  end
end
