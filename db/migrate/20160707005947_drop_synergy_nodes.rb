class DropSynergyNodes < ActiveRecord::Migration[5.0]
  def up
    drop_table :synergy_nodes
  end
end
