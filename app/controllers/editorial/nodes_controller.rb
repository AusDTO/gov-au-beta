module Editorial
  class NodesController < ::ApplicationController
    include ::NodesHelper

    before_action :load_lists, :derive_type, except: :show
    before_action :show_toolbar, only: :show

    def index
      authorize! :view, :editorial_page
      @section = Section.find_by slug: params[:section]
      @nodes = @section.nodes.order(updated_at: :desc).decorate
    end

    # TODO: show useful editorial things here rather than just showing the published version
    def show
      @node = Node.find(params[:id]).decorate
      @section = @node.section
      render_node @node, @section
    end

    def new
      @form = new_form
      @parent = Node.find(params[:parent]) if params[:parent] else nil

      if @parent
        @form.parent_id = @parent.id
        @form.section_id = @parent.section_id
      else
        @form.section_id = params[:section]
      end

    end

    def create
      @form = new_form
      if try_save
        redirect_to editorial_node_path(@form)
      else
        render :new
      end
    end

    def edit
      @node = Node.find(params[:id])
      @type_name = @node.class.name.underscore
      @form = "#{@node.class.name}Form".constantize.new(@node)
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
      raise 'Invalid type' unless %w{general_content news_article}.include?(@type_name)
      @type = @type_name.camelize.constantize
      @form_type = "#{@type.name}Form".constantize
    end

    def new_form(obj=nil)
      if obj
        @form_type.new(obj)
      else
        @form_type.new(@type.new(content_block: ContentBlock.new))
      end
    end

    def try_save
      return false unless @form.validate(params.require(:node).permit!)
      @form.sync
      @form.model.transaction do
        return false unless @form.model.save
        return false unless @form.model.content_block.save
      end
      return true
    end
  end
end
