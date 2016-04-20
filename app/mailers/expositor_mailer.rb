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

  def blueprint_file_mail(expositor, justification, state)
    @state = state == 'disapproved' ? 'Desaprobado' : state == 'approved' ? 'Aprobado' : 'Pre aprobado'
    @expositor = expositor
    @justification = justification
    mail(to: @expositor.email, subject: "PLANO #{@state.upcase}")
  end

  def catalog_email(expositor, justification, state)
    @state = state == 'disapproved' ? 'desaprobado' : 'pre aprobado'
    @expositor = expositor
    @justification = justification
    mail(to: @expositor.email, subject: "CATÁLOGO #{@state.upcase}")
  end
end
