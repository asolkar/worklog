class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :color
      t.integer :id
      t.integer :user_id

      t.timestamps
    end
  end
end
