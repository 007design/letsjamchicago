class RemoveStartTime < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :start_time
  end
end
