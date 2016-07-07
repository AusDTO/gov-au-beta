class SubmissionCreator

  def initialize(node, params, user)
    @node = node
    @submission = params[:node]
    @user = user
  end

  def already_exists?
    @node.submissions.open_submissions_for(@user).present?
  end

  def create_submission

    unless already_exists?
      return Submission.new(revision: @node.revise!(@submission))
    end

  end

  def open_submission
    @node.submissions.open_submissions_for(@user).last
  end

end