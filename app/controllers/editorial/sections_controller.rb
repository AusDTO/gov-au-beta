module Editorial
  class SectionsController < EditorialController
    def show
      @section = Section.find_by!(slug: params[:section])


      if params[:filter].present?
        case params[:filter]
          when 'submissions'
            @filter = 'submissions'
          when 'my_pages'
            @filter = 'my_pages'
          else
            @filter = nil
        end
      end
    end
  end
end

