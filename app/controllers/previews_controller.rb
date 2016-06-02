class PreviewsController < ApplicationController
  include NodesHelper
  include ContentHelper

  before_action :show_toolbar, only: :show

  def show
    preview = Preview.find_by!(token: params[:token]).decorate

    preview.content_blocks.each do |content_block|
      content_block.body = process_html content_block.body
    end

    # quack quack - preview acts as node (see NodesController)
    @node = preview
    @section = preview.section

    render_node @node, @section
  end

end
