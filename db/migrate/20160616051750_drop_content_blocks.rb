class DropContentBlocks < ActiveRecord::Migration[5.0]
  def up
    drop_table :content_blocks
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
