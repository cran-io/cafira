namespace :deadline_alerts do
  desc "Send mail notification when exposition's deadlines are not done yet"
  task :send_alert_emails => :environment do
    DeadlineAlerts.send
  end
end

class DeadlineAlerts
  def self.send
    Exposition.each do |exposition|
      exposition.expositors.near_deadline.each(exposition.days_to_notify_deadlines) do |expositor|
          ExpositorMailer.deadline_mail(expositor,exposition).deliver_later(wait: 10)
      end
    end

  end
end
