Fabricator(:department) do
  name { Fabricate.sequence(:department_name) { |i| "department-#{i}" } }
end
