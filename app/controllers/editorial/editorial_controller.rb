
module Editorial
  class EditorialController < ::ApplicationController

    check_authorization

    before_action ->() { authorize! :view, :editorial_page }

    layout 'editorial'

    def index
      authorize! :view, :editorial_page
      @sections = Section.all.order(:name).select{ |section| can? :read, section }
    end
  end
end
