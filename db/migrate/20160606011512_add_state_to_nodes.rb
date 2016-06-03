class AddStateToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :state, :string, null: false, default: 'draft'
  end
end
