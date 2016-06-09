Fabricator(:general_content) do
  name { Fabricate.sequence(:node_name) { |i| "node-#{i}" } }
  section
  state 'published'
end