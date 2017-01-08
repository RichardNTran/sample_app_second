class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailer.activation.subject")
  end

  def password_reset
    @greeting = t "mailer.reset_password.greeting"
    mail to: Settings.default_email_to
  end
end
