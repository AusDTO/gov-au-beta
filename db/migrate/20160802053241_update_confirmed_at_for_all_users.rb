class UpdateConfirmedAtForAllUsers < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.connection.execute <<-SQL
      update users set confirmed_at = now(), confirmation_sent_at = now() where confirmed_at is NULL;
    SQL
  end
end
