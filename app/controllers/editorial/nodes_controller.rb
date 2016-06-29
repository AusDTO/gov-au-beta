module Editorial
  class NodesController < Editorial::SectionsController
    include ::NodesHelper, ::EditorialHelper

    before_action :derive_type, except: [:show, :prepare]

    def index
      #TODO: evaluate whether this is required anymore!
      unless params[:section_id].present?
        redirect_to editorial_root_path
        return
      end

      @nodes = @section.nodes.order(updated_at: :desc).decorate
    end

    # TODO: show useful editorial things here rather than just showing the published version
    def show
      @node = Node.find(params[:id]).decorate
      render_node @node, @section
    end

    def prepare
      @type = Node
      @form_type = NodeForm
      configure_defaults!
      authorize! :create_in, @section

      @node_types = Node.descendants.map do |klass|
        name = klass.name.underscore
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
      if @form.validate(params.require(:node).permit!)
        submission = NodeCreator.new(@section, @form).perform!(current_user)
        redirect_to editorial_section_submission_path(@section, submission)
      else
        render :new
      end
    end

    def edit

      @node = Node.find(params[:id])
      authorize! :update, @node
      @type_name = @node.class.name.underscore
      @form = "#{@node.class.name}Form".constantize.new(@node)
      @editor = params[:editor]
      redirect_to new_editorial_section_submission_path(@section, node_id: @node, editor: @editor)
    end

    def update
      @node = Node.find(params[:id])
      authorize! :update, @node
      @form = new_form(@node)

      if try_save
        redirect_to editorial_node_path(@form)
      else
        render :edit
      end
    end

    private

    def derive_type
      @type_name = params[:type] || 'general_content'
      # Be extra pedantic with user input that is being turned into code
      @type = @type_name.camelize.constantize
      raise 'Invalid Type' unless @type.superclass.name == 'Node'
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
      return false unless @form.validate(params.require(:node).permit!)
      @form.sync
      @form.model.save
    end
  end
end
