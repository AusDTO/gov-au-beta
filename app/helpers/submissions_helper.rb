module SubmissionsHelper
  def can_review?
    return false unless submission.submitted?
    submission.section.present? && current_user.has_role?(:reviewer, submission.section)
  end

  def submission_exists?(node, user)
    !node.submissions.open_submissions_for(user).empty?
  end
end