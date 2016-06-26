module Editorial
  class NodesController < EditorialController
    include ::NodesHelper, ::EditorialHelper

    layout 'editorial'

    before_action :load_lists, :derive_type, except: [:show, :prepare]

    def index
      #TODO: evaluate whether this is required anymore!
      unless params[:section_id].present?
        redirect_to editorial_root_path
        return
      end

      @section = Section.find params[:section_id]
      @nodes = @section.nodes.order(updated_at: :desc).decorate
    end

    # TODO: show useful editorial things here rather than just showing the published version
    def show
      @node = Node.find(params[:id]).decorate
      @section = @node.section
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
      @editor = 'simplemde'
      configure_defaults!
      @form.prepopulate!
    end

    def create
      @form = new_form
      @form.prepopulate!

      if @form.validate(params.require(:node).permit!)
        submission = NodeCreator.new(@form).perform!(current_user)
        redirect_to editorial_submission_path(submission)
      else
        render :new
      end
    end

    def edit
      @node = Node.find(params[:id])
      @type_name = @node.class.name.underscore
      @form = "#{@node.class.name}Form".constantize.new(@node)
      @editor = params[:editor]
      redirect_to new_editorial_node_submission_path(@node, editor: @editor)
    end

    def update
      @node = Node.find(params[:id])
      @form = new_form(@node)

      if try_save
        redirect_to editorial_node_path(@form)
      else
        render :edit
      end

    end

    private

    def load_lists
      @sections = Section.all
    end

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
      @parent = Node.find(params[:parent]) if params[:parent].present? else nil

      @section = if @parent.present?
        @form.parent_id = @parent.id
        @parent.section
      elsif params[:section].present?
        Section.find params[:section]
      end

      @form.section_id = @section.id if @section.present?
    end

    def try_save
      return false unless @form.validate(params.require(:node).permit!)
      @form.sync
      @form.model.save
    end
  end
end
