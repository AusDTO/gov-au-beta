class AddCmsUrlToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :cms_url, :string
  end
end
