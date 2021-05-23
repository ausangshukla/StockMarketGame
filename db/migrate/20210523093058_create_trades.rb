class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |t|
      t.integer :order_id, null: false
      t.string :symbol, limit: 20, null: false
      t.integer :security_id, null: false
      t.integer :quantity, null: false
      t.float :price, null: false
      t.integer :buyer_id, null: false
      t.integer :seller_id, null: false

      t.timestamps
    end
    add_index :trades, :order_id
    add_index :trades, :security_id
  end
end
