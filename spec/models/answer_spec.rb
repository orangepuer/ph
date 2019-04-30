require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many :attachments }
  it { should have_many :comments }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe 'notify subscribers' do
    let(:answer) { build(:answer) }

    it 'calls SubscriberNotificationJob after create' do
      expect(SubscriberNotificationJob).to receive(:perform_later).with(answer)
      answer.save
    end
  end
end
