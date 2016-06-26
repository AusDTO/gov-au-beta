class AddNodeSourceFieldsToSections < ActiveRecord::Migration[5.0]
  def change
    add_column :sections, :cms_type, :string, :null => false, :default => "Collaborate"
    add_column :sections, :cms_url, :string
    add_column :sections, :cms_path, :string
  end
end
