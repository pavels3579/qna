require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let(:service) { double('Service::NewAnswerNotification') }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  before do
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls Service::NewAnswerNotification#notify' do
    expect(service).to receive(:notify)
    AnswerNotificationJob.perform_now(question)
  end
end
