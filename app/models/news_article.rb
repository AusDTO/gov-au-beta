class NewsArticle < Node
  store_schema :data do |s|
    s.datetime :release_date
  end
end