class AddTokenToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :token, :string, null: false
    add_index :nodes, :token, unique: true
  end
end
