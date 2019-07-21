require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :best_answer_awards }
  it { should have_many :comments }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'its_author?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    let(:question) { create(:question, author: user) }

    it 'returns true if user is author of resource' do
      expect(user).to be_its_author(question)
    end

    it 'returns false if user is not author of resource' do
      expect(another_user).not_to be_its_author(question)
    end
  end
end
