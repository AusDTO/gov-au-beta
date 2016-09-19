module Editorial
  class NodesController < Editorial::SectionsController
    include ::NodesHelper, ::EditorialHelper
    decorates_assigned :node
    decorates_assigned :menu_nodes, with: NodeDecorator

    before_action :derive_type, except: [:show, :prepare]


    def index
      #TODO: evaluate whether this is required anymore!
      unless params[:section_id].present?
        redirect_to editorial_root_path
        return
      end

      @nodes = @section.nodes.order(updated_at: :desc).decorate
      with_caching([*@nodes, @section])
    end

    def show
      @node = Node.find(params[:id])
      authorize! :read, @node
      @section = @node.section
      if @section
        @news = NewsArticle.published_for_section(@section).limit(3)
      end
      set_menu_nodes
      with_caching([*@nodes, *@news, @section])
    end

    def prepare
      @type = Node
      @form_type = NodeForm
      configure_defaults!
      authorize! :create_in, @section

      @node_types = creatable_type_list.map do |name|
        [I18n.t("domain_model.nodes.#{name}"), name]
      end

      @prompt = if @parent
        "below #{@parent.name}"
      else
        "in #{@section.name}"
      end
    end

    def new
      @editor = 'simple'
      configure_defaults!
      authorize! :create_in, @section
      @form.prepopulate!
    end

    def create
      @form = new_form
      @form.prepopulate!
      authorize! :create_in, @section
      if @form.validate(nodes_params)
        submission = NodeCreator.new(@section, @form).perform!(current_user)
        redirect_to editorial_section_submission_path(@section, submission)
      else
        render :new
      end
    end

    def edit
      @node = Node.find(params[:id])

      # TODO: find a better way to handle this when a pattern is more evident
      redirect_to edit_editorial_news_path(@node) if @node.type == 'NewsArticle'

      authorize! :update, @node
      @form = NodeMetadataForm.new(@node)
    end

    def update
      @node = Node.find(params[:id])
      authorize! :update, @node
      @form = NodeMetadataForm.new(@node)
      if try_save
        redirect_to editorial_section_node_path(@section, @node)
      else
        render :edit
      end
    end

    private

    def creatable_type_list
      [GeneralContent].map do |klass|
        klass.name.underscore
      end
    end

    def derive_type
      @type_name = params[:type] || 'general_content'
      # Be extra pedantic with user input that is being turned into code
      # This check MUST be done before the call to #constantize
      raise ClientParamError unless creatable_type_list.include?(@type_name)
      @type = @type_name.camelize.constantize
      @form_type = form_type(@type)
    end

    def new_form(obj=nil)
      obj = @type.new unless obj.present?
      @form_type.new obj
    end

    def configure_defaults!
      @form = new_form
      @parent = Node.find(params[:parent_id]) if params[:parent_id].present?
      @form.parent_id = @parent.id if @parent
    end

    def try_save
      return false unless @form.validate(nodes_params)
      @form.save
    end

    private

    def nodes_params
      # to debug, uncomment action_on_unpermitted_parameters
      # ActionController::Parameters.action_on_unpermitted_parameters = :raise
      params.required(:node).permit(:section_id, :parent_id, :name, :short_summary, :summary, :content_body,
                                    children_attributes: [:order_num, :id],
                                    options_attributes: [:toc,:suppress_in_nav,:placeholder])
    end
  end
end
