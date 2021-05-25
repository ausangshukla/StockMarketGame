class AddFillStatusToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :fill_status, :string, limit: 15
  end
end
