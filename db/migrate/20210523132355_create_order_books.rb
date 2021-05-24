class CreateOrderBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :order_books do |t|
      t.string :symbol, limit: 20
      t.integer :security_id

      t.timestamps
    end
    add_index :order_books, :security_id
  end
end
