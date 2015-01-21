require 'test_helper'

class SignUpMailerTest < ActionMailer::TestCase
  test "sign_up" do
    mail = SignUpMailer.sign_up
    assert_equal "Sign up", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "contact_us_notify" do
    mail = SignUpMailer.contact_us_notify
    assert_equal "Sign up", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
