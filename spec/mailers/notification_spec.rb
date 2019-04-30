require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "answer" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:mail) { NotificationMailer.answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Answer")
      expect(mail.to).to eq(["user.email"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end

end
