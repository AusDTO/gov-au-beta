class AddAncestryToRevisions < ActiveRecord::Migration[5.0]
  def change
    add_column :revisions, :parent_id, :uuid
  end
end
