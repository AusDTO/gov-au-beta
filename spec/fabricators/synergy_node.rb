Fabricator(:synergy_node) do
  source_url { Fabricate.sequence(:path) { |i| "http://example.com/path-#{i}" } }
  title { Fabricate.sequence(:title) { |i| "Some Title #{i}" } }
  slug { Fabricate.sequence(:slug) { |i| "slug-#{i}" } }
  path { Fabricate.sequence(:path) { |i| "path-#{i}" } }
  content { Fabricate.sequence(:content) { |i| { body: "Random content #{i}" }} }
end
