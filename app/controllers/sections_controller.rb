class SectionsController < ApplicationController
  include NodesHelper
  layout 'section'

  def index
    @sections = Section.all.order(:name)
    render layout: 'application'
  end

  def show
    @section = Section.find_by!(slug: params[:section])
    layout = @section.layout.presence
    @root_nodes = root_nodes @section
    
    if layout
      render layout: layout
    else
      render
    end
  end
end
