class NodesController < ApplicationController
  include NodesHelper
  include ContentHelper

  before_action :show_toolbar, only: :show

  def show
    @section = Section.find_by! slug: params[:section]
    @node = find_node!(@section, params[:path]).decorate
    @toolbar_info[:edit_url] = @node.edit_url

    if @node.content_block
      @node.content_block.body = process_html(@node.content_block.body)
    end

    layout = @section.layout.presence

    if layout
      render "templates/#{@node.template}", layout: layout
    else
      render "templates/#{@node.template}"
    end
  end
end