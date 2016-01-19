class AddEmailStatusToMassiveEmails < ActiveRecord::Migration
  def change
  	add_column :massive_mails, :sent, :boolean, :default => false
  end
end
