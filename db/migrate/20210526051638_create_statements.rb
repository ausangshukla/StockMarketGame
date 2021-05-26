class CreateStatements < ActiveRecord::Migration[6.1]
  def change
    create_table :statements do |t|
      t.text :particulars
      t.float :debit
      t.float :credit
      t.float :net
      t.string :stmt_type, limit: 10
      t.integer :user_id
      t.integer :ref_id
      t.string :ref_type, limit: 30

      t.timestamps
    end
    add_index :statements, :user_id
    add_index :statements, :ref_id
  end
end
