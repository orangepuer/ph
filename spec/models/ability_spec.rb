require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: another_user), user: user }

    it { should be_able_to :update, create(:answer, question: question, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, question: question, user: another_user), user: user }

    it { should be_able_to :update, create(:comment, commentable: question, user: user), user: user }
    it { should_not be_able_to :update, create(:comment, commentable: question, user: another_user), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: another_user), user: user }

    it { should be_able_to :destroy, create(:answer, question: question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: another_user), user: user }

    it { should be_able_to :destroy, create(:comment, commentable: question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:comment, commentable: question, user: another_user), user: user }
  end
end