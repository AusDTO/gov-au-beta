module Editorial
  class SectionsController < EditorialController
    def show
      @section = Section.find_by!(slug: params[:section])
      params.fetch(:filter, nil).permit(:submissions, :my_pages)
    end
  end
end

