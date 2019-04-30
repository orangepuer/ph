class Services::SubscriberNotification
  def send_answer(answer)
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      NotificationMailer.answer(subscription.user, answer).deliver_later
    end
  end
end