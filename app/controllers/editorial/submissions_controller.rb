module Editorial
  class Editorial::SubmissionsController < Editorial::SectionsController
    include ::EditorialHelper

    before_action :find_node, only: [:new, :create]
    before_action :check_submission_validity, only: [:new, :create]
    before_action :find_submission, only: [:show, :update]
    decorates_assigned :submission


    def index
      @submissions = scope.open.for(current_user)
    end

    def create
      @submission = SubmissionCreator.new(@node, params, current_user).create!

      if @submission.submit! current_user

        MetricsRecorder.instance.revisions_submitted.increment()

        flash[:notice] = "Your changes have been submitted"
        redirect_to editorial_section_submission_path(@section, @submission)
      end
    end

    def new

      @editor = params[:editor] || 'simple'
    end

    def update
      # Note: Once we support an author modifying a submission, this may need to be refactored
      authorize! :review, @submission
      if params[:accept]
        @submission.accept!(current_user)
        redirect_to nodes_path(@submission.revisable.path)
      elsif params[:reject]
        @submission.reject!(current_user)
        redirect_to editorial_section_submission_path(@section, @submission)
      else
        flash[:alert] = 'Unknown update action'
        redirect_to editorial_section_submission_path(@section, @submission)
      end
    end

    private

    def find_node
      @node = Node.find params[:node_id]
      @form = form_type(@node.class).new @node
    end

    def find_submission
      @submission = scope.find(params[:id])
    end

    def scope
      if @section.present?
        Submission.of_section(@section)
      else
        Submission
      end
    end


    def check_submission_validity

      # Will need to revert back to the below at some point
      # However, for now, we only want one Submission per Node...
      #if @node.submission_exists_for? current_user
      if @node.submissions.open.present?
        submission = @node.submissions.open.last
        redirect_to editorial_section_submission_path(submission.section, submission)
      end

    end
  end
end
