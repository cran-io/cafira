class AddDaysToNotifyDeadlinesToExposition < ActiveRecord::Migration
  def change
    add_column :expositions, :days_to_notify_deadlines, :integer
  end
end
