require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, author: users[0]) }

  it 'sends new answer notification to subscribed user' do
    expect(NewAnswerMailer).to receive(:send_notification).with(question.author, question).and_call_original
    subject.notify(question)
  end

  it 'does not send new answer notification to non subscribed user' do
    expect(NewAnswerMailer).to_not receive(:send_notification).with(users[1], question).and_call_original
  end
end
