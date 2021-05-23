class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :user_id, null: false
      t.string :side, limit: 5, null: false
      t.string :symbol, limit: 20, null: false
      t.integer :security_id, null: false
      t.integer :quantity, null: false
      t.float :price
      t.string :price_type, limit: 10, null: false
      t.string :order_type, limit: 10, null: false
      t.string :qualifier, limit: 10
      t.integer :linked_short_cover_id
      t.integer :filled_qty
      t.integer :open_qty
      t.string :status, limit: 10, null: false

      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :security_id
  end
end
