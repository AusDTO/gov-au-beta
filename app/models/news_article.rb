class NewsArticle < Node
  store_accessor :data, :release_date

  def default_form
    NewsArticleForm.new self
  end

end