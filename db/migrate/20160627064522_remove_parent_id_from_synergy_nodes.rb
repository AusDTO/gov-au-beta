class RemoveParentIdFromSynergyNodes < ActiveRecord::Migration[5.0]
  def change
    remove_column :synergy_nodes, :parent_id
  end
end
