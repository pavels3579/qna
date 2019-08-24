require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { create(:question, user: create(:user)) }

  it 'calls ReputationJob' do
    expect(Services::Reputation).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end
end
