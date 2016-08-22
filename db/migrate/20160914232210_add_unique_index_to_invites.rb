class AddUniqueIndexToInvites < ActiveRecord::Migration[5.0]
  def change
    #Drop previous indexes and recreate with unique
    remove_index :invites, :code
    remove_index :invites, :accepted_token

    add_index :invites, :code, :unique => true
    add_index :invites, :accepted_token, :unique => true
  end
end
