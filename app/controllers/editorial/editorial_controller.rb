
module Editorial
  class EditorialController < ::ApplicationController

    before_action ->() { authorize! :view, :editorial_page }

    layout 'editorial'

    def index
      authorize! :view, :editorial_page
      @sections = Section.all.order(:name)
    end
  end
end