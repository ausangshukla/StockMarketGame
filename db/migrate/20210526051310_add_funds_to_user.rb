class AddFundsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :available_margin, :float
    add_column :users, :used_margin, :float
    add_column :users, :available_cash, :float
    add_column :users, :opening_balance, :float
  end
end
