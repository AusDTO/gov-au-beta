class CreateSynergyNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :synergy_nodes do |t|
      t.references :parent

      t.text :name, null: false
      t.text :source, null: false
      t.json :data, null: false

      t.integer :order_num
      t.timestamps
    end
  end
end
