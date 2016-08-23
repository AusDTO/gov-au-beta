class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug, index: true
      t.text :short_summary
      t.text :summary
      t.column :parent_id, :integer
      t.column :children_count, :integer

      t.timestamps
    end
    create_table :section_categories, id: false do |t|
      t.belongs_to :section, index: true
      t.belongs_to :category, index: true
    end
  end
end
