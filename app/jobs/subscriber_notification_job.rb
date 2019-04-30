class SubscriberNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::SubscriberNotification.new.send_answer(answer)
  end
end
