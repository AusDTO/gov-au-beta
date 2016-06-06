class Editorial::NodesController < ApplicationController

  before_action :load_lists, :derive_type

  def index
    @section = Section.find_by slug: params[:section]
    @nodes = @section.nodes.order(updated_at: :desc).decorate
  end

  def new
    @form = @type.new(content_block: ContentBlock.new).default_form
  end

  def create
    @form = @type.new(content_block: ContentBlock.new).default_form
    if @form.validate(params[:node]) && @form.save
      # TODO: redirect to draft view when we have one
      redirect_to @form.model.full_path
    else
      render 'new'
    end
  end

  private

  def load_lists
    @sections = Section.all
  end

  def derive_type
    @type_name = params[:type] || 'general_content'
    @type = @type_name.camelize.constantize
    raise 'Invalid type' unless @type <= Node
  end

end
