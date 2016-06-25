class AddStateToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :state, :string, null: false, default: 'draft'
    remove_column :submissions, :accepted, :boolean, null: false, default: false
  end
end
