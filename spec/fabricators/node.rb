Fabricator(:node) do
  name { Fabricate.sequence(:node_name) { |i| "node-#{i}" } }
  uuid { SecureRandom.uuid }
  template 'default'
  section
end