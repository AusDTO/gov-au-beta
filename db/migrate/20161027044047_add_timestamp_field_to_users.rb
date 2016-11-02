class AddTimestampFieldToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :totp_timestamp, :timestamp
  end
end
