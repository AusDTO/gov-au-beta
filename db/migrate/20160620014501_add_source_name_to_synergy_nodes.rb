class AddSourceNameToSynergyNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :synergy_nodes, :source_name, :string, null: false
    add_index :synergy_nodes, :source_name, unique: false
  end
end
