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
        Array.wrap(transients[role]).each do |section|
          user.add_role(role[0..-4], section)
        end
      end
    end

    if transients[:owner_of]
      Array.wrap(transients[:owner_of]).each do |section|
        user.add_role(:owner, section)
      end
    end
  end
end
