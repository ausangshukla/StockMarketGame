class CreateNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news do |t|
      t.string :news_type, limit: 30
      t.text :details

      t.timestamps
    end
  end
end
