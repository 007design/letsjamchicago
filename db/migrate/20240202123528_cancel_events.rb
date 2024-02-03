class CancelEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :cancelled, :boolean
  end
end
