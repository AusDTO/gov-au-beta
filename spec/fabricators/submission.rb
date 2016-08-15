Fabricator(:submission) do
  transient :revisable, :revision
  submitter { Fabricate(:user) }

  after_build do |submission, transients|
    if transients[:revision]
      submission.revision = transients[:revision]
    else
      submission.revision = if transients[:revisable]
        Fabricate(:revision, revisable: transients[:revisable])
      else
        Fabricate(:revision)
      end
    end
  end

  after_create do |submission, _transients|
    submission.submitter.add_role(:author_of, submission.revision.revisable.section)
  end
end
