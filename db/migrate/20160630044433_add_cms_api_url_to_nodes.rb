class AddCmsApiUrlToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :cms_api_url, :string
  end
end
