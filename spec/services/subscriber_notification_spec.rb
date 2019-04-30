require 'rails_helper'

RSpec.describe Services::SubscriberNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:subscriptions) { create_list(:subscription, 3, user: create(:user), question: question) }
  let(:answer) { create(:answer, user: user, question: question) }

  it 'answer should be send to subscribers' do
    subscriptions.each do |subscription|
      expect(NotificationMailer).to receive(:answer).with(subscription.user, answer).and_call_original
    end
    subject.send_answer(answer)
  end
end