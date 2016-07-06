Fabricator(:minister) do
  name { Fabricate.sequence(:minister_name) { |i| "minister-#{i}" } }
end
