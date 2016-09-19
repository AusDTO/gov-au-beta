module Editorial
  class SectionsController < EditorialController
    before_action :find_section
    before_action ->() { authorize! :read, @section }, unless: :skip_view_section_auth?
    decorates_assigned :section
    decorates_assigned :users, with: UserDecorator
    layout 'editorial_section'


    def show
      @filter = %w(my_pages submissions).detect { |f| f == params[:filter] }
      with_caching(@section)  
    end

    # TODO this should be a show/index on another resource.
    def collaborators
      @pending = Request.where(section: @section, state: :requested)
      @users = @section.users
      with_caching([*@pending, *@users])
    end

    protected

    def skip_view_section_auth?
      false
    end

    private

    def find_section
      @section = Section.find params[:section_id]
    end
  end
end

