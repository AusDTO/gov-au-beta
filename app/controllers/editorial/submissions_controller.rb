module Editorial
  class Editorial::SubmissionsController < Editorial::SectionsController
    include ::EditorialHelper

    before_action :find_node, only: [:new, :create]
    before_action :find_submission, only: [:show, :update]
    decorates_assigned :submission


    def index
      @submissions = scope.open_submissions_for(current_user)
    end

    def create
      @submission = Submission.new(revision: @node.revise!(params[:node]))

      if @submission.submit! current_user
        flash[:notice] = "Your changes have been submitted to #{@node.name}"
        redirect_to editorial_section_submission_path(@section, @submission)
      end
    end

    def new
      @editor = params[:editor]
    end

    def update
      # Note: Once we support an author modifying a submission, this may need to be refactored
      authorize! :review, @submission
      if params[:accept]
        @submission.accept!(current_user)
        redirect_to nodes_path(section: @submission.section, path: @submission.revisable.path)
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
  end
end
