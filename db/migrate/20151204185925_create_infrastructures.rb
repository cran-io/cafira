class CreateInfrastructures < ActiveRecord::Migration
  def change
    create_table :infrastructures do |t|

      t.timestamps null: false
    end
  end
end
