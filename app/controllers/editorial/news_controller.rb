module Editorial
  class NewsController < EditorialController
    before_action :set_sections_by_membership, only: [:index, :new, :create]

    def index
      # TODO: return news index
    end

    def show
      @article = NewsArticle.find_by(slug: params[:article_slug])
    end

    # New action should provide a form with the appropriate sections to
    # link to, but not require this to be selected. The section will
    # represent the publisher of the news article.
    #
    # A list of sections should also be provided to create 'distributions',
    # which should be formed based on the user's membership access. Selecting
    # one of these sections would create a distribution, which would ensure
    # that the news item was displayed on its news section.
    def new
      @editor = 'simple'
      @form = NewsArticleForm.new(NewsArticle.new)
    end

    def create
      @form = NewsArticleForm.new(NewsArticle.new)
      @form.prepopulate!


      if @form.validate(params.require(:node).permit!)

        # TODO: Handle draft news submissions that are yet to have
        #       a section assigned to it. This could be handled via a
        #       /editorial/submissions route which would display submissions
        #       for current_user

        section = Section.find(@form.section_id)
        @form.parent_id = Section.find_by(name: 'news').home_node.id
        submission = NodeCreator.new(section, @form).perform!(current_user)

        if submission.submit! current_user
          flash[:notice] = 'Your changes have been submitted'
          redirect_to editorial_section_submission_path(@section, @submission)
        end

      else
        render :new
      end
    end

    private
    def set_sections_by_membership
      @sections = current_user.member_sections
    end
  end
end