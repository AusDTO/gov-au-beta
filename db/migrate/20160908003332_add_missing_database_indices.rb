class AddMissingDatabaseIndices < ActiveRecord::Migration[5.0]
  def change
    add_index :nodes, :type
    add_index :sections, :type
  end
end
