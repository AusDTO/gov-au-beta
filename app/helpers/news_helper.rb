module NewsHelper
  def news_article_class
    if @section.present?
      return 'content-main'
    end

    'content-listing'
  end


  # Loads news articles and preloads all associated relationships to be able to
  # render the news page without any further database roundtrips.
  #
  # To load articles for a Section, use `preload_news_articles(section.news_articles)`
  def preload_news_articles(query_root = NewsArticle)
    query_root
      .preload([
        {:section  => {:home_node => :parent}},
        {:sections => {:home_node => :parent}}
      ])
      .published
      .by_release_date
      .by_published_at
      .by_name
  end


  # List of Ministers for filtering
  def ministers_list
    Minister.order(:name).decorate.sort_by! { |minister| minister.sort_order }
  end


  # List of Departments for filtering
  def departments_list
    Department.order(:name)
  end
end
