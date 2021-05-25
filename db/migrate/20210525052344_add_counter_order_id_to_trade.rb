class AddCounterOrderIdToTrade < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :counterparty_order_id, :integer
    add_index :trades, :counterparty_order_id
  end
end
