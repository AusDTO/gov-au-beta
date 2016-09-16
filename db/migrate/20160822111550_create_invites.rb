class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.string :code
      t.string :accepted_token
      t.timestamp :accepted_at
      t.string :email
      t.timestamps
    end
    add_index :invites, :code
    add_index :invites, :accepted_token
  end
end
