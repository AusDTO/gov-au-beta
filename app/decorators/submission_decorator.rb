class SubmissionDecorator < Draper::Decorator
  delegate_all
  decorates_association :submitter
  decorates_association :reviewer
  decorates_association :revisable
  delegate :full_name, to: :submitter, prefix: true, allow_nil: true
  delegate :full_name, to: :reviewer, prefix: true, allow_nil: true

  def submitted_content
    RevisionContent.new(revision)
  end

  # returns nil if there is no original content
  #
  # Note: This works if
  #   (a) a submission only has one revision and its parent is applied
  #   (b) the submission is not yet applied
  # If a submission has multiple revisions and is then applied, this will return
  # an intermediate revision rather than the original base. Once we support multiple
  # revisions per submission, this will need to be revisited.
  def original_content
    last_applied = revision.ancestors.find(&:applied?)
    RevisionContent.new(last_applied) if last_applied
  end
end
