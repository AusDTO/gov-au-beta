class AddAlttextToAssets < ActiveRecord::Migration[5.0]
  def change
    add_column :assets, :alttext, :string
  end
end
