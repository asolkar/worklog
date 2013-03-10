class AddGplusResourcesToUser < ActiveRecord::Migration
  def change
    add_column :users, :gplus_refresh_token, :string
    add_column :users, :gplus_display_name, :string
    add_column :users, :gplus_profile_url, :string
    add_column :users, :gplus_avatar_url, :string
  end
end
