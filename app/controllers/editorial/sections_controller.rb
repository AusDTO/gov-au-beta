module Editorial
  class SectionsController < ApplicationController
    def index
      authorize! :view, :editorial_page
      @sections = Section.all.order(:name)
    end
  end
end

