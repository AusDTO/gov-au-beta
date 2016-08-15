class AddPhoneConfirmationOtpFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :unconfirmed_phone_number, :string
    add_column :users, :identity_verified_at, :datetime
  end
end
