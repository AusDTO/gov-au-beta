class AddTokenToNodes < ActiveRecord::Migration[5.0]
  def up
    add_column :nodes, :token, :string

    Node.all.each do |node|
      node.update_column :token, SecureRandom.uuid
    end

    add_index :nodes, :token, unique: true
  end

  def down
    remove_index :nodes, :token
    remove_column :nodes, :token
  end
end
