class AddPathToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :synergy_nodes, :path, :string, :null => false
    add_index :synergy_nodes, :path, :unique => true
  end
end
