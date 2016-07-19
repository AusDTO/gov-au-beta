module Editorial
  class NewsController < EditorialController
    before_action :set_sections_by_membership, only: [:index, :new, :create]

    def index
      # TODO: return news editorial index
    end

    def show
      @article = NewsArticle.find_by(slug: params[:article_slug])
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
        @form.parent_id = @news_home.id
        section = Section.find(@form.section_id)
        submission = NodeCreator.new(section, @form).perform!(current_user)

        flash[:notice] = 'Your changes have been submitted'
        redirect_to editorial_section_submission_path(section, submission)
      else
        render :new
      end
    end

    private

    # A list of sections should be provided to create 'distributions',
    # which should be formed based on the user's membership access.
    def set_sections_by_membership
      @sections = current_user.member_of_sections.reject do |section|
        section.news?
      end
      @news_home = Section.find_by(name: 'news').home_node
    end
  end
end