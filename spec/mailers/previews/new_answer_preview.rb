# Preview all emails at http://localhost:3000/rails/mailers/new_answer_mailer
class NewAnswerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_mailer/send_notification
  def send_notification
    NewAnswerMailer.send_notification
  end

end
