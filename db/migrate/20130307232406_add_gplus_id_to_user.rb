class AddGplusIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :gplus_id, :string
  end
end
