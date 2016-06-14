class CreateSynergyNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :synergy_nodes do |t|
      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true
      t.integer :depth, :null => false, :default => 0
      t.integer :children_count, :null => false, :default => 0

      t.text :name, null: false
      t.text :source, null: false
      t.json :data, null: false

      t.timestamps
    end
  end
end
