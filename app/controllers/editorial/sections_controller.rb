module Editorial
  class SectionsController < EditorialController
    def show
      @section = Section.find_by!(slug: params[:section])
      @filter = %w(my_pages submissions).detect { |f| f == params[:filter] }
    end

    def collaborators
      @section = Section.find_by!(slug: params[:section])

      @pending = Request.where(section: @section, state: :requested)

      #Find all the collaborators and roles on @section
      @users_and_roles = Hash.new([])
      Section.find_roles.pluck(:name).uniq.each do |role|
        User.with_role(role, @section).each do |user|
          @users_and_roles[user] += [role]
        end
      end
    end
  end
end

