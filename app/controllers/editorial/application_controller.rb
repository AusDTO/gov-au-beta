
module Editorial
  class ApplicationController < ::ApplicationController

    before_action ->() { authorize! :view, :editorial_page }

  end
end
