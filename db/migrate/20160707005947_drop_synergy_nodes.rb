class DropSynergyNodes < ActiveRecord::Migration[5.0]
  def up
    drop_table :synergy_nodes, if_exists: true
  end
end
