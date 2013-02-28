class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :tag
      t.belongs_to :entry

      t.timestamps
    end
    add_index :taggings, :tag_id
    add_index :taggings, :entry_id
  end
end
