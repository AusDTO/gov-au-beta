module Editorial
  class RequestsController < EditorialController
    def new
      @section = Section.find(params[:section])
      @form = RequestForm.new(Request.new(section: @section))
    end

    def create

    end
  end
end