class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :id
      t.text :body
      t.integer :log_id

      t.timestamps
    end
  end
end
