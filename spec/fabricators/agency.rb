Fabricator(:agency) do
  name { Fabricate.sequence(:agency_name) { |i| "agency-#{i}" } }
end