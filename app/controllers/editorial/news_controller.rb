module Editorial
  class NewsController < EditorialController
    before_action :set_sections_by_membership, only: [:index, :new, :create, :edit]

    def index
      # TODO: return news editorial index
    end

    def show
      @article = NewsArticle.find_by(
        section: params[:section],
        slug: params[:slug]
      )

    end

    def new
      @editor = 'simple'
      @form = NewsArticleForm.new(NewsArticle.new)
      if params[:publisher].present?
        @form.section_id = params[:publisher]
      end
    end

    def create
      @form = NewsArticleForm.new(NewsArticle.new)
      @form.prepopulate!

      # TODO: Handle draft submissions with no sections.
      # This could be handled via a user's context under /editorial/submissions.
      if @form.validate(params.require(:node).permit!)

        # TODO: move this into a form validator
        # Prevents distribution list being created for publisher
        @form.section_ids.reject! do |s_id|
          s_id == @form.section_id
        end

        section = Section.find(@form.section_id)
        submission = NodeCreator.new(section, @form).perform!(current_user)

        flash[:notice] = 'Your changes have been submitted'
        redirect_to editorial_section_submission_path(section, submission)
      else
        render :new
      end
    end

    def edit
      @node = Node.find(params[:id])
      authorize! :update, @node
      @form = NewsArticleMetadataForm.new(@node)
    end

    def update
      @node = Node.find(params[:id])
      authorize! :update, @node
      @form = NewsArticleMetadataForm.new(@node)

      if @form.validate(params.require(:node))
        @form.section_ids.reject! do |s|
          s == @form.section_id.to_s
        end

        @form.save do |params|
          @node.section_ids = params[:section_ids]
          @node.release_date = params[:release_date]
          @node.section_id = params[:section_id]
          @node.save!
        end

        redirect_to @node.full_path
      end
    end

    private

    # A list of sections should be provided to create 'distributions',
    # which should be formed based on the user's membership access.
    def set_sections_by_membership
      @sections = current_user.member_of_sections
    end
  end
end