class AddSourceUrlToSynergyNodes < ActiveRecord::Migration[5.0]
  def change
    change_column :synergy_nodes, :source_url, :string, null: false
    add_index :synergy_nodes, :source_url, unique: false
  end
end
