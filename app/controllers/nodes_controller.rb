class NodesController < ApplicationController
  include NodesHelper

  decorates_assigned :node
  decorates_assigned :menu_nodes, with: NodeDecorator

  def show
    @node = Node.find_by_path! params[:path] || ''
    raise ActiveRecord::RecordNotFound unless can? :read, @node
    @section = @node.section
    set_menu_nodes
    render_node node
  end

  def home
    @news = NewsArticle.published.limit(8).all

    @ministers = Minister.all

    @departments = Department.all

    @agencies = Agency.all

    show
  end

  def preview
    @node = Node.find_by_token!(params[:token])
    @section = @node.section
    set_menu_nodes
    render_node node
  end
end
