require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :best_answer_awards }
  it { should have_many :comments }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user) { create(:user) }
  let(:user_not_verified) { create(:user, email: 'temp@tempusermail.com') }

  describe 'its_author?' do
    let(:another_user) { create(:user) }

    let(:question) { create(:question, author: user) }

    it 'returns true if user is author of resource' do
      expect(user).to be_its_author(question)
    end

    it 'returns false if user is not author of resource' do
      expect(another_user).not_to be_its_author(question)
    end
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe 'email_verified?' do
    it 'returns true if email doesn\'t include tempusermail string' do
      expect(user).to be_email_verified
    end

    it 'returns false if email include tempusermail string' do
      expect(user_not_verified).not_to be_email_verified
    end
  end

end
