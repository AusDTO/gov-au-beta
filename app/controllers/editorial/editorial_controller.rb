
module Editorial
  class EditorialController < ::ApplicationController

    before_action ->() { authorize! :view, :editorial_page }

  end
end
