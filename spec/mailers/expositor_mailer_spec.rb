require "rails_helper"

RSpec.describe ExpositorMailer, type: :mailer do
  describe "signup_mail" do
    let(:expositor) { Expositor.create(:email=> "expositor@mail.com", :password => "12345678", :password_confirmation => "12345678")}
    let(:mail) { ExpositorMailer.signup_mail(expositor,"123455678") }

    it "renders the headers" do
      expect(mail.subject).to eq("ALTA DE SOCIO CAFIRA")
      expect(mail.from).to eq(["noreply@cafira.com"])
      expect(mail.to).to eq(["expositor@mail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded.empty?).to be false
    end
  end

  describe "deadline_mail" do
    let(:expositor) { Expositor.create(:email=> "expositor@mail.com", :password => "12345678", :password_confirmation => "12345678")}
    let(:mail) { ExpositorMailer.deadline_mail(expositor) }

    it "renders the headers" do
      expect(mail.subject).to eq("PLAZO POR VENCER CAFIRA")
      expect(mail.from).to eq(["noreply@cafira.com"])
      expect(mail.to).to eq(["expositor@mail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded.empty?).to be false
    end
  end


end
