class AddSourceRefToSynergyNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :synergy_nodes, :cms_ref, :string
  end
end
