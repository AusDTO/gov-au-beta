require "administrate/base_dashboard"

class GeneralContentDashboard < NodeDashboard
  # Overwrite this method to customize whether the index page for general contents
  # is included in the sidebar.
  #
  def show_in_sidebar?
    true
  end
end
