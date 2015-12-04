class CreateBlueprints < ActiveRecord::Migration
  def change
    create_table :blueprints do |t|

      t.timestamps null: false
    end
  end
end
