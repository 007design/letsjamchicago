class AddNeighborhoodsToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :neighborhood, :string
  end
end
