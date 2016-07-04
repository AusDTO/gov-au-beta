class CreateTableSectionsSections < ActiveRecord::Migration[5.0]
  def change
    create_table :section_connections do |t|
      t.integer :section_id
      t.integer :connection_id
    end

    add_index(:section_connections, [:section_id, :connection_id], :unique => true)
  end
end
