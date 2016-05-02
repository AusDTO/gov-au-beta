class CreateContentBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :content_blocks do |t|
      t.references :node, foreign_key: true
      t.text :body
      t.string :name

      t.timestamps
    end
  end
end
