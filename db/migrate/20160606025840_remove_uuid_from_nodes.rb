class RemoveUuidFromNodes < ActiveRecord::Migration[5.0]
  def change
    remove_column :nodes, :uuid, :string, null: false
  end
end
