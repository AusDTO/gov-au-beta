class ChangeSynergyNodesSourceUrlToNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :synergy_nodes, :source_url, :string, null: true
  end
end
