class CreateMassiveMails < ActiveRecord::Migration
  def change
    create_table :massive_mails do |t|
    	t.string :subject
      t.text :body
      t.attachment :attachment

      t.timestamps null: false
    end
  end
end
