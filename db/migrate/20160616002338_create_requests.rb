class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.references :section
      t.references :user
      t.references :owner
      t.string :state, default: 'requested', null: false
      t.text :message

      t.timestamps
    end
  end
end
