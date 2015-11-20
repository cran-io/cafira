# Preview all emails at http://localhost:3000/rails/mailers/expositor_mailer
class ExpositorMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/expositor_mailer/signup_confirmation
  def signup_confirmation
    ExpositorMailer.signup_confirmation
  end

end
