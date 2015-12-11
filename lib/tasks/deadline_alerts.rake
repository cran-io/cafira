namespace :deadline_alerts do
  desc "Send mail notification when exposition's deadlines are not done yet"
  task :send_weekly_email => :environment do
    DeadlineAlerts.send
  end
end

class DeadlineAlerts
  def self.send
    Expositor.near_deadline.each do |expositor|
        ExpositorMailer.deadline_mail(expositor).deliver
    end
  end
end
