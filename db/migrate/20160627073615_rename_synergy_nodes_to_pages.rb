class RenameSynergyNodesToPages < ActiveRecord::Migration[5.0]
  def change
    rename_table :synergy_nodes, :pages
  end
end
