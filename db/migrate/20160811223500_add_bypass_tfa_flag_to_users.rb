class AddBypassTfaFlagToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :bypass_tfa, :boolean, default: false
  end
end
