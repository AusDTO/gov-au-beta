class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :name
      t.string :preview_image_id
      t.string :preview_image_filename
      t.string :preview_image_size
      t.string :preview_image_content_type
      
      t.timestamps
    end
  end
end
