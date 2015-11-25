class ExpositorMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.expositor_mailer.signup_mail.subject
  #
  def signup_mail(expositor, expositor_password)
    @expositor = expositor
    @password = expositor_password

    mail(to: @expositor.email, subject: "ALTA DE SOCIO CAFIRA")
  end

  def deadline_mail(expositor)
    @expositor = expositor

    mail(to: @expositor.email, subject: "PLAZO POR VENCER CAFIRA")
  end

end
