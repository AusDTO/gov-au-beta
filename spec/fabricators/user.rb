Fabricator(:user) do
  email { Fabricate.sequence(:email) { |i| "user-#{i}@example.com" } }
  password { "qwerty1234" }
  transient :is_admin, :author_of, :reviewer_of, :owner_of

  after_build do |user, transients|
    if transients[:is_admin]
      user.add_role(:admin)
    end
    if transients[:author_of]
      user.add_role(:author, transients[:author_of])
    end
    if transients[:reviewer_of]
      user.add_role(:reviewer, transients[:reviewer_of])
    end

    if transients[:owner_of]
      user.add_role(:owner, transients[:owner_of])
    end
  end
end

