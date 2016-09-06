module NewsHelper
  def news_article_class
    if @section.present?
      return 'content-main'
    end

    'content-listing'
  end

  def news_articles(section: nil)
    if section.present?
      section.news_articles.published.by_release_date.by_published_at
    else
      NewsArticle
          .includes(:news_distributions,
                    sections: [:home_node]
          )
          .published
          .by_release_date
          .by_published_at
    end
  end
end
