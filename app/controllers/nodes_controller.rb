class NodesController < ApplicationController
  include NodesHelper
  layout 'section'
  decorates_assigned :node

  decorates_assigned :root_nodes, with: NodeDecorator

  def show
    @section = Section.find_by! slug: params[:section]
    @raw_node = @section.find_node!(params[:path])
    if !can?(:read, @raw_node)
      raise ActiveRecord::RecordNotFound
    end
    @node = @raw_node
    @root_nodes = @section.nodes.without_parent
    render_node node, @section
  end

  def preview
    @node = Node.find_by_token!(params[:token])
    @section = @node.section
    @root_nodes = @section.nodes.without_parent
    render_node node, @section
  end
end
