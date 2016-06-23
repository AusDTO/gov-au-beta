class NodesController < ApplicationController
  include NodesHelper
  layout 'section'

  def show
    @section = Section.find_by! slug: params[:section]
    @raw_node = @section.find_node!(params[:path])
    if !can?(:read, @raw_node)
      raise ActiveRecord::RecordNotFound
    end
    @node = @raw_node.decorate
    render_node @node, @section
  end

  def preview
    @node = Node.find_by_token!(params[:token]).decorate
    @section = @node.section
    render_node @node, @section
  end
end
