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

  def preview
    @node = Node.find_by_token!(params[:token])
    @section = @node.section
    set_menu_nodes
    render_node node
  end

  private

  def set_menu_nodes
    if @section.present? && @section.home_node.present?
      @menu_nodes = @section.home_node.children.published
    end
  end
end
