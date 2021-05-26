class CreatePositions < ActiveRecord::Migration[6.1]
  def change
    create_table :positions do |t|
      t.string :name, limit: 30
      t.integer :user_id
      t.integer :security_id
      t.string :symbol, limit: 10
      t.integer :quantity
      t.float :average_cost
      t.float :current_value
      t.float :eod_value

      t.timestamps
    end
    add_index :positions, :user_id
    add_index :positions, :security_id
  end
end
