module Editorial
  class SectionsController < EditorialController
    def show
      @section = Section.find_by!(slug: params[:section])
      @filter = %w(my_pages submissions).detect { |f| f == params[:filter] }
    end
  end
end

