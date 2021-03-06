require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many :answers }
  it { should have_many :attachments }
  it { should have_many :comments }
  it { should have_many :subscriptions }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe 'reputation' do
    let(:question) { build(:question) }
    
    it 'calls ReputationJob after create' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save
    end
  end
end
