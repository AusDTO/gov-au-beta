class AddAccountVerifiedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :account_verified, :boolean
  end
end
