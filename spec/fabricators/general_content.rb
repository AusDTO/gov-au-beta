Fabricator(:general_content) do
  name { Fabricate.sequence(:node_name) { |i| "node-#{i}" } }
  content_block { Fabricate(:content_block) }
  section
  state 'published'
end