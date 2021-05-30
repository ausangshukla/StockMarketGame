class ChangeTransId < ActiveRecord::Migration[6.1]
  def change
    change_column :trades, :transaction_id, :string, limit:40
  end
end
