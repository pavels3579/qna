require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:users).through(:subscriptions) }
  it { should belong_to(:author) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:question) { create :question, author: user }
    let(:model) { create :answer, question: question, author: user }
  end

  describe 'reputation' do
    let(:question) { build(:question, author: create(:user)) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

end
