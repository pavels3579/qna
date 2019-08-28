require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe "send_notification" do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:mail) { NewAnswerMailer.send_notification(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("Send notification")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("New Question Answer Notification")
    end
  end

end
