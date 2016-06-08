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
end