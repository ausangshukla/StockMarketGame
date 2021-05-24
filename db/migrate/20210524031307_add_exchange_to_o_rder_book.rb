class AddExchangeToORderBook < ActiveRecord::Migration[6.1]
  def change
    add_column :order_books, :exchange_id, :integer
    add_index :order_books, :exchange_id
  end
end
