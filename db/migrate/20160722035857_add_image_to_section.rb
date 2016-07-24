class AddImageToSection < ActiveRecord::Migration[5.0]
  def change
    add_column :sections, :image_url, :text
  end
end
