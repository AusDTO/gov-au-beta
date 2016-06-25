class CreateNodeHierarchies < ActiveRecord::Migration
  def change
    create_table :node_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :node_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "node_anc_desc_idx"

    add_index :node_hierarchies, [:descendant_id],
      name: "node_desc_idx"
  end
end
