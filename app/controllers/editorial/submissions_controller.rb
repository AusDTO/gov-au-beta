class Editorial::SubmissionsController < ApplicationController
  include ::EditorialHelper
  layout 'editorial_section'

  before_action :find_node, only: [:new, :create]
  before_action :find_submission, only: [:show, :update]
  before_action :find_section
  decorates_assigned :submission


  def index
    if params[:section]
      @section = Section.find_by_slug(params[:section])
    end
    @submissions = scope.open_submissions_for(current_user)

    # @new_submissions = user_submissions.with_unpublished_node
    # @existing_submissions = user_submissions.with_published_node
  end

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
  end

  def update
    # Note: Once we support an author modifying a submission, this may need to be refactored
    authorize! :review, @submission
    if params[:accept]
      @submission.accept!(current_user)
      redirect_to nodes_path(section: @submission.section, path: @submission.revisable.path)
    elsif params[:reject]
      @submission.reject!(current_user)
      redirect_to editorial_submission_path(@submission)
    else
      flash[:alert] = 'Unknown update action'
      redirect_to editorial_submission_path(@submission)
    end
  end

  private

  def find_node
    @node = Node.find params[:node_id]
    @form = form_type(@node.class).new @node
  end

  def find_submission
    @submission = Submission.find(params[:id])
  end

  def scope
    if params[:section]
      Submission.of_section(Section.find_by_slug([params[:section]]))
    else
      Submission
    end
  end

  def find_section
    @section = if params[:section]
      Section.find_by_slug(params[:section])
    elsif @node
        @node.section
    else
      @submission.revisable.section
    end
  end
end