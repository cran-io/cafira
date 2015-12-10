class AddDeadlinesToExpositions < ActiveRecord::Migration
  def change
    add_column :expositions, :deadline_calalogs, :date
    add_column :expositions, :deadline_credentials, :date
    add_column :expositions, :deadline_aditional_services, :date
    add_column :expositions, :deadline_infrastructures, :date
  end
end
