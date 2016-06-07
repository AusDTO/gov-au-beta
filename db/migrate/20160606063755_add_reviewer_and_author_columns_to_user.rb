class AddReviewerAndAuthorColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_author, :boolean, null: false, default: false
    add_column :users, :is_reviewer, :boolean, null: false, default: false
  end
end
