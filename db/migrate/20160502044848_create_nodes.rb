class CreateNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :nodes do |t|
      t.references :section
      t.references :template
      t.references :parent
      t.string :name
      t.string :slug
      t.integer :order_num
      t.timestamps
    end
  end
end
