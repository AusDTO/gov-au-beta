class SubmissionCreator

  def initialize(node, params, user)
    @node = node
    @sub_params = params[:node]
    @user = user
  end


  def create!

    unless @node.submission_exists_for?(@user)
      return Submission.new(revision: @node.revise!(@sub_params))
    end

  end

  def open_submission
    @node.submissions.open.for(@user).last
  end

end