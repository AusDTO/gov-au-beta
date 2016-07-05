module Editorial
  class SectionsController < EditorialController
    before_action :find_section
    decorates_assigned :section
    decorates_assigned :users, with: UserDecorator
    layout 'editorial_section'

    def show
      @filter = %w(my_pages submissions).detect { |f| f == params[:filter] }
    end

    def collaborators
      @pending = Request.where(section: @section, state: :requested)
      @users = @section.users
    end

    private

    def find_section
      @section = Section.find params[:section_id]
    end
  end
end

