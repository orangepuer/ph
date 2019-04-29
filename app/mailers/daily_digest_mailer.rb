class DailyDigestMailer < ApplicationMailer

  def digest(user)
    @user = user
    @questions = Question.created_recently

    mail to: "user.email"
  end
end
