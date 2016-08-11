class CreateDataBundles < ActiveRecord::Migration[5.0]
  def change
    create_table :data_bundles do |t|
      t.references :node
      t.string :type
      t.timestamps
    end
  end
end
