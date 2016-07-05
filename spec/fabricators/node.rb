Fabricator(:node) do
  name { Fabricate.sequence(:node_name) { |i| "node-#{i}" } }
  section {|attrs| Fabricate(:section) unless attrs[:parent].try(:section).present? }
  state 'published'
  content_body { Fabricate.sequence(:content_body) { |i| "Random content #{i}" } }

  after_build {|node, _transients|
    unless node.parent.present?
      node.parent = node.section.home_node
    end }
end

Fabricator(:general_content, from: :node, class_name: :general_content) do
  name { Fabricate.sequence(:general_content_name) { |i| "general_content-#{i}" } }
end

Fabricator(:news_article, from: :node, class_name: :news_article) do
  name { Fabricate.sequence(:news_name) { |i| "news-#{i}" } }
end

Fabricator(:root_node, class_name: :root_node) do
  # name { '' }
  state 'published'
  content_body 'Welcome to gov.au'
end

Fabricator(:section_home, class_name: :section_home, from: :node) do
end
