Fabricator(:news_article) do
  name { Fabricate.sequence(:news_name) { |i| "news-#{i}" } }
  content_block { Fabricate(:content_block) }
  section
  state 'published'
end