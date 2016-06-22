module Editorial
  class SectionsController < EditorialController
    def show
      @section = Section.find_by!(slug: params[:section])
      @filter = %w(my_pages submissions).detect { |f| f == params[:filter] }
    end

    def collaborators
      @section = Section.find_by!(slug: params[:section])
      @pending = Request.where(section: @section, state: :requested)
      @collaborators = @section.users.map(&:decorate)
    end
  end
end

