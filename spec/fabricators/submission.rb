Fabricator(:submission) do
  revision
  submitter { Fabricate(:user) }
  after_create {|submission, _t|
    submission.submitter.add_role(:author_of,
      submission.revision.revisable.section)}
end
