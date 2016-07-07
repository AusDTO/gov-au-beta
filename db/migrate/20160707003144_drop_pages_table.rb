class DropPagesTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :pages
  end
end
