class ExpositorMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.expositor_mailer.signup_confirmation.subject
  #
  def signup_confirmation(expositor, expositor_password)
    @expositor = expositor
    @password = expositor_password

    mail(to: @expositor.mail, subject: "BIENVENIDO A CAFIRA")
  end
end
