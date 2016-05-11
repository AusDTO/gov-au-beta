class AddUuidToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :uuid, :string, null: false
    add_column :content_blocks, :unique_id, :string, null: false
  end
end
