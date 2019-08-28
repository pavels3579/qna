class Services::NewAnswerNotification
  def notify(question)
    question_subscribers = question.users
    question_subscribers.each do |user|
      NewAnswerMailer.send_notification(user, question).deliver_later
    end
  end
end
