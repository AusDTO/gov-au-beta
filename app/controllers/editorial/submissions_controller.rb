class Editorial::SubmissionsController < ApplicationController
  include ::EditorialHelper

  before_action :find_node, only: [:new, :create]
  decorates_assigned :submission

  def create
    @submission = Submission.new(revision: @node.revise!(params[:node]))

    if @submission.submit! current_user
      flash[:notice] = "Your changes have been submitted to #{@node.name}"
      redirect_to editorial_submission_path @submission
    end
  end

  def new
    @editor = params[:editor]
  end

  def show
    @submission = Submission.find(params[:id])
  end

  private

  def find_node
    @node = Node.find params[:node_id]
    @form = form_type(@node.class).new @node
  end
end
