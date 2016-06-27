class AddSlugColumnToSynergyNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :synergy_nodes, :slug, :string
  end
end
