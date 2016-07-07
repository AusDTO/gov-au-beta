class SubmissionCreator

  def initialize(node, params)
    @node = node
    @submission = params[:node]
  end

  def already_exists?
    @node.submissions.open_submission_for(current_user).empty?
  end

  def create_submission

    if already_exists?
      open_submission
    else
      @submission = Submission.new(revision: @node.revise!(params[:node]))
    end

  end

  def open_submission
    @node.submissions.open_submission_for(current_user).last
  end


end