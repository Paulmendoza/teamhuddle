# Preview all emails at http://localhost:3000/rails/mailers/sign_up_mailer
class SignUpMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/sign_up_mailer/sign_up
  def sign_up
    SignUpMailer.sign_up
  end

  def contact_us
    @contact_us = ContactUs.first

    SignUpMailer.contact_us_notify(@contact_us)
  end



end
