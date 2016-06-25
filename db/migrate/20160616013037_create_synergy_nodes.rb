class CreateSynergyNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :synergy_nodes do |t|
      t.references :parent
      t.string  :slug
      t.string  :source_url
      t.integer :position
      t.jsonb   :content
      t.timestamps
    end
  end
end
