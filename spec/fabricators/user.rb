Fabricator(:user) do
  email { Fabricate.sequence(:email) { |i| "user-#{i}@example.com" } }
  password { "qwerty1234" }
  is_admin { false }
  is_author { false }
  is_reviewer { false }
end

