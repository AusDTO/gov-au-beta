class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :name
      t.string :slug
      t.string :preview_image_id

      t.timestamps
    end
  end
end
