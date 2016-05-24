class AddReasonToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalogs, :reason, :integer
  end
end
