module Editorial
  class NewsController < EditorialController
    include ::NodesHelper
    before_action :set_sections_by_membership, only: [:index, :new, :create, :edit]
    before_action ->() { authorize! :create, :news }, only: [:new, :create]

    def index
      # TODO: return news editorial index
      with_caching(@sections)
    end

    def show
      @article = NewsArticle.find_by(
        section: params[:section],
        slug: params[:slug]
      )
      authorize! :read, @article
      with_caching([*@sections, @article])
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
      if @form.validate(news_params)
        if current_user.is_member?(Section.find(@form.section_id))
          # TODO: move this into a form validator
          @form.section_ids.reject! do |s_id|
            s_id.blank? || !current_user.is_member?(Section.find(s_id))
          end

          # Ensure the publisher is _always_ added to the distribution list
          @form.section_ids.append @form.section_id\
            if !@form.section_ids.include? @form.section_id

          section = Section.find(@form.section_id)
          submission = NodeCreator.new(section, @form).perform!(current_user)

          flash[:notice] = 'Your changes have been submitted'
          redirect_to editorial_section_submission_path(section, submission)
          return
        end
      end

      # TODO: this is a kludge, but it works.
      if @form.release_date.class.name == 'String'
        @form.release_date = DateTime.parse(@form.release_date)
      end

      render :new
    end

    def edit
      @node = Node.find(params[:id])
      authorize! :update, @node
      @form = NewsArticleMetadataForm.new(@node)
    end

    # TODO: DRY up create and update into a service object
    def update
      @node = Node.find(params[:id])
      authorize! :update, @node
      @form = NewsArticleMetadataForm.new(@node)

      if @form.validate(params.require(:node))
        if current_user.is_member?(Section.find(@form.section_id))
          @form.section_ids.reject! do |s_id|
            s_id.blank? || !current_user.is_member?(Section.find(s_id))
          end

          # Ensure the publisher is _always_ added to the distribution list
          @form.section_ids.append @form.section_id\
            if !@form.section_ids.include? @form.section_id

          @form.save do |params|
            @node.section_ids = params[:section_ids]
            @node.release_date = params[:release_date]
            @node.section_id = params[:section_id]
            @node.save!
          end

          redirect_to public_node_path(@node)
          return
        end
      end

      render :edit
    end

    private

    # A list of sections should be provided to create 'distributions',
    # which should be formed based on the user's membership access.
    def set_sections_by_membership
      @sections = current_user.member_of_sections
    end

    def news_params
      params.required(:node).permit(:section_id, {section_ids: []}, :parent_id, :name, :short_summary,
                                    :summary, :content_body, :options, :release_date)
    end
  end
end
