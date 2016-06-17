class AddTitleToSynergyNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :synergy_nodes, :title, :text
  end
end
