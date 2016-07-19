class CreateNewsDistributions < ActiveRecord::Migration[5.0]
  def change
    create_table :news_distributions do |t|
      t.references :distribution, polymorphic: true, index: { name: 'index_news_distro_on_type_and_id' }
      t.timestamps
    end
  end
end
