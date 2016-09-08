module NewsHelper
  def news_article_class
    if @section.present?
      return 'content-main'
    end

    'content-listing'
  end

  def news_articles(section: nil)
    query_root = if section.present?
                   section.news_articles
                 else
                   NewsArticle
                 end
    query_root
      .preload([
        {:section =>  {:home_node => :parent}},
        {:sections => {:home_node => :parent}}])
      .published
      .by_release_date
      .by_published_at
      .by_name
  end
end
