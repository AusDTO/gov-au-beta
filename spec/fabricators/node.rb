Fabricator(:node) do
  name { Fabricate.sequence(:node_name) { |i| "node-#{i}" } }
  section
  state 'published'  
  content_blocks(count: 1)# { |attrs, i| Fabricate(:content, name: "Kid #{i}") }
end