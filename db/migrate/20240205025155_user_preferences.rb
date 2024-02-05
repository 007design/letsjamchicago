class UserPreferences < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :show_attending, :boolean, :default => true
    add_column :users, :neighborhoods, :string
    add_column :users, :findable, :boolean, :default => false
  end
end
