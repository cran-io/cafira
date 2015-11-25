namespace :deadline_alerts do
  desc "Send mail notification when exposition's deadlines are not done yet"
  task :send_weekly_email => :environment do
    DeadlineAlerts.send
  end
end

class DeadlineAlerts
  def self.send
    @date = DateTime.now
    Exposition.opened.expositors each do |e|
      #logica para saber si un expositor de una Exposicion esta al dia.

     end
  end
end
