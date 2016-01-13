class AddCampaignIdToMassiveMails < ActiveRecord::Migration
  def change
  	add_column :massive_mails, :campaign, :string
  end
end
