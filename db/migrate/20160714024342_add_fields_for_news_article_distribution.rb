class AddFieldsForNewsArticleDistribution < ActiveRecord::Migration[5.0]
  def change
    add_column :news_distributions, :acknowledged, :boolean
    add_column :news_distributions, :news_article_id, :integer
  end
end
