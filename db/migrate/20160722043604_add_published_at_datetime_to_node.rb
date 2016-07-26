class AddPublishedAtDatetimeToNode < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :published_at, :timestamp
  end
end
