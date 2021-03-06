require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should belong_to(:question).touch(true) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'mark_as_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:another_answer) { create(:answer, question: question, author: user) }

    it 'cheks setting answer as best' do
      answer.mark_as_best
      expect(answer.best).to be_truthy
    end

    it 'only one answer is the best ' do
      answer.mark_as_best
      another_answer.mark_as_best

      expect(question.answers.where(best: true).count).to eq 1
    end

    it 'cheks not setting another answer as best' do
      answer.mark_as_best
      expect(another_answer.best).to be_falsey
    end
  end

  it_behaves_like 'votable' do
    let(:model) { create :question, author: user }
  end

end
