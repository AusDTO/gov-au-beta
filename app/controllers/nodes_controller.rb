class NodesController < ApplicationController
  include NodesHelper

  before_action :show_toolbar, only: :show

  def show
    # TODO should only work on published?
    @section = Section.find_by! slug: params[:section]
    @node = find_node!(@section, params[:path]).decorate
    @toolbar_info[:edit_url] = @node.edit_url

    render_node @node, @section
  end

  def new
    @parent = Node.find(params[:parent]) if params[:parent] else nil

    if @parent
      @node = @parent.children.build
      @node.section = @parent.section
    else
      @section = Section.find(params[:section])
      @node = @section.nodes.build
    end

    @form = NodeForm.new(@node)
  end

  def create
    @form = NodeForm.new(Node.new)

    if @form.validate(params.require(:node).permit!)

      @form.save do |hash|
        node = Node.new(hash)
        # TODO: UUID may not be required
        node.uuid = SecureRandom.uuid
        node.save
      end

    else
      render :new
    end
  end

  def edit
    @node = Node.find(params[:id])
    @form = NodeForm.new(@node)
  end

  def update
    @node = Node.find(params[:id])
    @form = NodeForm.new(@form)

    if @form.validate(params.require(:node).permit!)
      @form.save do |hash|
        @node.update_attributes(hash)
        @node.save!
      end
    else
      render :edit
    end

  end
end