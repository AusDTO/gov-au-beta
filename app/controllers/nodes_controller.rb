class NodesController < ApplicationController
  include NodesHelper

  before_action :show_toolbar, only: :show

  def show
    @section = Section.find_by! slug: params[:section]
    @raw_node = @section.find_node!(params[:path])
    if !can?(:read, @raw_node)
      raise ActiveRecord::RecordNotFound
    end
    @node = @raw_node.decorate
    @toolbar_info[:edit_url] = @node.edit_url
    render_node @node, @section
  end

  def preview
    @node = Node.find_by_token!(params[:token]).decorate
    @section = @node.section
    render_node @node, @section
  end
end
