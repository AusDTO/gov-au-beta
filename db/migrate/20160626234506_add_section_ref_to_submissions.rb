class AddSectionRefToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_reference :submissions, :section, foreign_key: true
  end
end
