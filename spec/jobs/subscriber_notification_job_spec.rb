require 'rails_helper'

RSpec.describe SubscriberNotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:service) { double('Services::SubscriberNotification') }

  before { allow(Services::SubscriberNotification).to receive(:new).and_return(service) }

  it 'calls Services::SubscriberNotification#send_answer' do
    expect(service).to receive(:send_answer)
    SubscriberNotificationJob.perform_now(answer)
  end
end
