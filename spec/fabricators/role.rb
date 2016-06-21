Fabricator(:role) do
  name { Fabricate.sequence(:role_name) { |i| "role-#{i}" } }
end