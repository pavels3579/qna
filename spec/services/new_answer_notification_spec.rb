require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  it 'sends new answer notification to subscribed user' do
    expect(NewAnswerMailer).to receive(:send_notification).with(user, question).and_call_original
    subject.notify(question)
  end
end
