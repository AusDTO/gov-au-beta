class MakeAgenciesDepartments < ActiveRecord::Migration[5.0]
  def up
    sql = "UPDATE sections SET type = 'Department' WHERE type = 'Agency'"
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
