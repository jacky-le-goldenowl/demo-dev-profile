class UserMailer < ApplicationMailer
  def reset_password_mailer(user, new_password)
    @user = user
    @new_password = new_password

    return if @user.email.blank?

    mail to: @user.email, subject: 'Password changed'
  end

  def welcome_email(user)
    @user = user
    return if @user.email.blank?

    mail to: @user.email, subject: 'Welcome to Billing System.'
  end
end
