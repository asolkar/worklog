class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :fullname
      t.integer :id
      t.string :email
      t.string :password_digest
      t.string :avatar

      t.timestamps
    end
  end
end
