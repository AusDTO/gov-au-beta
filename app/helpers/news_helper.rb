module NewsHelper
  def news_article_class
    if @section.present?
      return 'content-main'
    end

    'content-listing'
  end
end