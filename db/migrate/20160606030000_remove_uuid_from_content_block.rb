class RemoveUuidFromContentBlock < ActiveRecord::Migration[5.0]
  def change
    remove_column :content_blocks, :unique_id, :string, null: false
  end
end
