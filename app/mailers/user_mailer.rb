class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: t(".subject_account_activation")
  end

  def password_reset user
    @user = user
    mail to: @user.email, subject: t(".subject_password_reset")
  end
end
