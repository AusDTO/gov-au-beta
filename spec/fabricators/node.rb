Fabricator(:node) do
  name { Fabricate.sequence(:node_name) { |i| "node-#{i}" } }
  section
  state 'published'
  content_body { Fabricate.sequence(:content_body) { |i| "Random content #{i}" } }
end