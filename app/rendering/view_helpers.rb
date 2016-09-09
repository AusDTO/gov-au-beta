# Allow easy access to view helpers from normal ruby objects
# Usage: ViewHelpers.instance.<view-method>
# Eg:    ViewHelpers.instance.link_to('home', '/')
class ViewHelpers
  include Singleton
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include NodesHelper
end