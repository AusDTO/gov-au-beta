class FixRequestOwnerColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :requests, :owner_id, :approver_id
  end
end
