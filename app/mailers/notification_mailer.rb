class NotificationMailer < ApplicationMailer

  def answer(user, answer)
    @user = user
    @answer = answer

    mail to: "user.email"
  end
end
