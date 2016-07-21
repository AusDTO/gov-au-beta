class MakeAgencyRolesDepartmentRoles < ActiveRecord::Migration[5.0]
  def up
    sql = "UPDATE roles SET resource_type = 'Department' WHERE resource_type = 'Agency'"
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
