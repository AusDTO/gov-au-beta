class Editorial::NodesController < ApplicationController
  include NodesHelper
  include ContentHelper

  before_action :load_lists, :derive_type, except: :show
  before_action :show_toolbar, only: :show

  def index
    @section = Section.find_by slug: params[:section]
    @nodes = @section.nodes.order(updated_at: :desc).decorate
  end

  def new
    @form = new_form
  end

  def create
    @form = new_form
    if @form.validate(params[:node]) && @form.save
      # TODO: redirect to draft view when we have one
      redirect_to @form.model.full_path
    else
      render 'new'
    end
  end

  def show
    @node = Node.find_by_token!(params[:token]).decorate
    @section = @node.section
    @toolbar_info[:edit_url] = @node.edit_url

    if @node.content_block
      @node.content_block.body = process_html(@node.content_block.body)
    end

    render_node @node, @section
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

  def new_form
    @form_type.new(@type.new(content_block: ContentBlock.new))
  end
end
