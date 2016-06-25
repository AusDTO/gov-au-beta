class CreateRevisionHierarchies < ActiveRecord::Migration
  def change
    create_table :revision_hierarchies, id: false do |t|
      t.uuid :ancestor_id, null: false
      t.uuid :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :revision_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "revision_anc_desc_idx"

    add_index :revision_hierarchies, [:descendant_id],
      name: "revision_desc_idx"
  end
end
