class AddTransIdToTrade < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :transaction_id, :integer
    add_index :trades, :transaction_id
  end
end
