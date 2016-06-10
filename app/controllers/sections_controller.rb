class SectionsController < ApplicationController

  before_action :show_toolbar, only: :show
  
  def index
    @sections = Section.all.order(:name)
  end

  def show
    @section = Section.find_by!(slug: params[:section])
    layout = @section.layout.presence
    @root_nodes = @section.nodes.where(:parent => nil)
    if layout
      render layout: layout
    else
      render
    end
  end
end
