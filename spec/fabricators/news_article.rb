Fabricator(:news_article) do
  name { Fabricate.sequence(:news_name) { |i| "news-#{i}" } }
  section
  state 'published'
end