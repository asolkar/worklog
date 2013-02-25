class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :id
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
