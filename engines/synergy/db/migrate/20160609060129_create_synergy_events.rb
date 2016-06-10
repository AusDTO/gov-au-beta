class CreateSynergyEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :synergy_events do |t|
      t.text :source, null: false
      t.json :payload, null: false

      t.timestamps
    end
  end
end
