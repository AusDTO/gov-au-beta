class SectionsController < ApplicationController
  layout 'section'

  decorates_assigned :menu_nodes, with: NodeDecorator

  def index
    @sections = Section.all.order(:name)
    render layout: 'application'
  end

  def show
    @section = Section.find_by!(slug: params[:section])
    layout = @section.layout.presence
    @menu_nodes = @section.nodes.published.without_parent

    if layout
      render layout: layout
    else
      render
    end
  end
end
