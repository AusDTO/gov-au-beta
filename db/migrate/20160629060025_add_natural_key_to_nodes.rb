class AddNaturalKeyToNodes < ActiveRecord::Migration[5.0]
  def change
    # NOTE: the caveat is that for root nodes when the parent_id is null, it's possible
    # to have multiple nodes with the same slug. For this to really work, we need to coerce
    # NULL to a value or use partial indices.
    add_index :nodes, [:parent_id, :slug], :unique => true
  end
end
