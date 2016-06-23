class SectionsController < ApplicationController
  layout 'section'

  def index
    @sections = Section.all.order(:name)
    render layout: 'application'
  end

  def show
    @section = Section.find_by!(slug: params[:section])
    layout = @section.layout.presence
    @root_nodes = @section.nodes.where(:parent => nil).decorate
    
    if layout
      render layout: layout
    else
      render
    end
  end
end
