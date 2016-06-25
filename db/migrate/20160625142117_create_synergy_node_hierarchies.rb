class CreateSynergyNodeHierarchies < ActiveRecord::Migration
  def change
    create_table :synergy_node_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :synergy_node_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "synergy_node_anc_desc_idx"

    add_index :synergy_node_hierarchies, [:descendant_id],
      name: "synergy_node_desc_idx"
  end
end
