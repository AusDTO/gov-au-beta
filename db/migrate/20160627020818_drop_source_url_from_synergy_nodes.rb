class DropSourceUrlAndSlugFromSynergyNodes < ActiveRecord::Migration[5.0]
  def up
    remove_column :synergy_nodes, :source_url
    remove_column :synergy_nodes, :slug
  end
end
