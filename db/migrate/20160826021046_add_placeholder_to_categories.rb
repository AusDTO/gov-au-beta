class AddPlaceholderToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :placeholder, :boolean, null: false, default: false
  end
end
