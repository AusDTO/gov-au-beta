Fabricator(:invite) do
  email { Fabricate.sequence(:email) { |i| "user-#{i}@some-agency.gov.au" } }
end
