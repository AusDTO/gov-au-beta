module Editorial
  class SectionsController < ::ApplicationController
    def index
      authorize! :create, Node
      @sections = Section.all.order(:name)
    end
  end
end

