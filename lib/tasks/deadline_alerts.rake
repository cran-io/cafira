namespace :deadline_alerts do
  desc "Send mail notification when exposition's deadlines are not done yet"
  task :send_alert_emails => :environment do
    DeadlineAlerts.send
  end
end

class DeadlineAlerts
  def self.send
    Expositor.near_deadline.each do |expositor|
        ExpositorMailer.deadline_mail(expositor).deliver_later(wait: 10)
    end
  end
end
