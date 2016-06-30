module Editorial
  class SectionsController < EditorialController
    before_action :find_section
    decorates_assigned :section
    layout 'editorial_section'

    def show
      @filter = %w(my_pages submissions).detect { |f| f == params[:filter] }
    end

    def collaborators
      @pending = Request.where(section: @section, state: :requested)
      @collaborators = @section.users.map(&:decorate)
    end

    private
      def find_section
        @section = Section.find_by!(slug: params[:section_id])
      end
  end
end

