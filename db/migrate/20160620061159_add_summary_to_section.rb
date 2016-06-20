class AddSummaryToSection < ActiveRecord::Migration[5.0]
  def change
    add_column :sections, :summary, :text
  end
end
