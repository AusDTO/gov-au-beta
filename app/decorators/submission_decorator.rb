class SubmissionDecorator < Draper::Decorator
  delegate_all
  decorates_association :submitter
  delegate :full_name, to: :submitter, prefix: true, allow_nil: true

  def submitted_at
    object.submitted_at.try(:strftime, '%d %b %Y, %I:%M%P') || '-'
  end

  def submitted_content
    RevisionContent.new(revision)
  end
end
