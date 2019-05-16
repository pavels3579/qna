require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  describe 'mark_as_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:another_answer) { create(:answer, question: question, author: user) }

    it 'cheks setting answer as best ' do
      expect(answer.mark_as_best).to eq (answer.best = true)
    end

    it 'only one answer is the best ' do
      answer.mark_as_best
      another_answer.mark_as_best

      expect(Answer.where(best: true).count).to eq 1
    end
  end

end
