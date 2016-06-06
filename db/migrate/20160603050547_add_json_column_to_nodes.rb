class AddJsonColumnToNodes < ActiveRecord::Migration[5.0]
  def change
    change_table :nodes do |t|
      t.text :type
      t.jsonb :data
    end
  end
end
