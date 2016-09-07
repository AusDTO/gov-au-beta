module NewsHelper
  def news_article_class
    if @section.present?
      return 'content-main'
    end

    'content-listing'
  end

  def news_articles(section: nil)
    if section.present?
      section.news_articles
          .includes(:news_distributions,
                    section: [:home_node],
          )
          .published
          .by_release_date
          .by_published_at
    else
      NewsArticle
          .includes(:news_distributions,
                    section: [:home_node],
          # GIVES ActionView::Template::Error (The association scope 'related_sections' is instance dependent (the scope block takes an argument). Preloading instance dependent scopes is not supported.):
          #           related_sections: [:home_node]
          )
          .published
          .by_release_date
          .by_published_at
    end
  end
end
