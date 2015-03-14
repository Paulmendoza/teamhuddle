class SignUpMailer < ActionMailer::Base

  layout 'base_email'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sign_up_mailer.sign_up.subject
  #
  def welcome(user)

    mail to: user.email, subject: "Welcome to Teamhuddle"
  end

  def contact_us_notify(contact_us_form)
    @contact_us_form = contact_us_form

    mail to: Rails.env.production? ? "contact@teamhuddle.ca" : "akos_sebestyen@hotmail.com",
         subject: "Teamhuddle Feedback from #{contact_us_form.first_name} #{contact_us_form.last_name}",
         from: contact_us_form.email
  end
end
