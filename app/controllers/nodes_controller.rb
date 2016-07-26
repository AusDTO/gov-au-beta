class NodesController < ApplicationController
  include NodesHelper

  decorates_assigned :node
  decorates_assigned :menu_nodes, with: NodeDecorator

  def show

    @node = Node.find_by_path! params[:path] || ''

    raise ActiveRecord::RecordNotFound unless can? :read, @node
    @section = @node.section
    if @section
      @news = NewsArticle.published_for_section(@section).limit(3)
    end
    set_menu_nodes
    render_node node
  end

  def home
    @news = NewsArticle.by_release_date.by_published_at.published.limit(8)
    @ministers = Minister.all
    @departments = Department.all
    @agencies = Agency.all
    @categories = STATIC_CATEGORIES #TODO Replace once categories are proper data
    show
  end

  def preview
    @node = Node.find_by_token!(params[:token])
    @section = @node.section
    set_menu_nodes
    render_node node
  end
end
