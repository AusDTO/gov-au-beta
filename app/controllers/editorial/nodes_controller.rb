class Editorial::NodesController < ApplicationController
  def index
    @section = Section.find_by slug: params[:section]
    @nodes = @section.nodes.order(updated_at: :desc).decorate
  end
end
