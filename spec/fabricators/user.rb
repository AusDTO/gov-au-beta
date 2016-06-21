Fabricator(:user) do
  email { Fabricate.sequence(:email) { |i| "user-#{i}@example.com" } }
  password { "qwerty1234" }
  transient :is_admin, :author_of, :reviewer_of, :owner_of

  after_build do |user, transients|
    if transients[:is_admin]
      user.add_role(:admin)
    end
    [:author_of, :reviewer_of, :owner_of].each do |role|
      if transients[role]
        user.add_role(role[0..-4], transients[role])
      end
    end
  end
end

