class AddMapToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :map, :string
  end
end
