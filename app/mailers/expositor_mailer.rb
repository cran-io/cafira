class ExpositorMailer < ApplicationMailer
  def signup_mail(expositor, expositor_password)
    @expositor = expositor
    @password = expositor_password

    mail(to: @expositor.email, subject: "ALTA DE SOCIO CAFIRA")
  end

  def deadline_mail(expositor)
    @expositor = expositor

    mail(to: @expositor.email, subject: "PLAZO POR VENCER CAFIRA")
  end

  def dissaproved_blueprint_file(expositor, justification)
    @expositor = expositor
    @justification = justification
    mail(to: @expositor.email, subject: "PLANO DESAPROBADO")
  end
end
