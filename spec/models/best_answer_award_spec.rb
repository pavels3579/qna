require 'rails_helper'

RSpec.describe BestAnswerAward, type: :model do
  it { should belong_to :question }
  it { is_expected.to belong_to(:user).optional }

  it { should validate_presence_of :title }

  it 'has one attached image' do
    expect(BestAnswerAward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
