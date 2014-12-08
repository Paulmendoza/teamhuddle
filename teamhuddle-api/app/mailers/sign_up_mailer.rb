class SignUpMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sign_up_mailer.sign_up.subject
  #
  def welcome(user)

    mail to: user.email, subject: "Welcome to Teamhuddle"
  end
end
