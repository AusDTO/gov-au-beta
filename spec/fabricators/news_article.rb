Fabricator(:news_article, from: :node, class_name: :news_article) do
  name { Fabricate.sequence(:news_name) { |i| "news-#{i}" } }
end