namespace :deadline_alerts_test do
  desc "Send mail notification when exposition's deadlines are not done yet"
  task :send_test => :environment do
    DeadlineAlerts.send
  end
end

class DeadlineAlerts
  def self.send
    ExpositorMailer.signup_mail(User.first,"raketest").deliver
  end
end
