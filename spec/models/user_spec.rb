require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :subscriptions }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#subscribed?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, user: user, question: question) }

    it 'User should be subscribed to question' do
      expect(user).to be_subscribed(question)
    end

    it 'Another user does not subscribed to question' do
      expect(another_user).to_not be_subscribed(question)
    end
  end
end
