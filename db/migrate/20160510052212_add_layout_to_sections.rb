class AddLayoutToSections < ActiveRecord::Migration[5.0]
  def change
    add_column :sections, :layout, :string, null: true
  end
end
