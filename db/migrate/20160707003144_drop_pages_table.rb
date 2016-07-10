class DropPagesTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :pages, if_exists: true
  end
end
