class CreatePreviews < ActiveRecord::Migration[5.0]
  def change
    create_table :previews do |t|
      t.string :token
      t.json :body

      t.timestamps
    end
  end
end
