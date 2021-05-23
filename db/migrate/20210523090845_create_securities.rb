class CreateSecurities < ActiveRecord::Migration[6.1]
  def change
    create_table :securities do |t|
      t.string :sec_type, limit: 10, null: false
      t.string :symbol, limit: 20, null: false
      t.string :name, limit: 100, null: false
      t.float :prev_closing_price, :default => 0
      t.float :opening_trade_price, :default => 0
      t.float :day_high_price,:default => 0
      t.float :day_low_price, :default => 0
      t.float :price, :default => 0
      t.bigint :market_cap, :default => 0
      t.float :pe, :default => 0
      t.datetime :last_trade_date

      t.timestamps
    end

    add_index :securities, :symbol, unique: true
  end
end
