class NewsArticle < Node
  #store :data, coder: JSON

  #store_accessor :data, :release_date

  store_schema :data do |s|
    s.datetime :release_date
  end
end