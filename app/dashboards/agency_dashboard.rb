require "administrate/base_dashboard"

class AgencyDashboard < SectionDashboard

  SHOW_PAGE_ATTRIBUTES = (self.superclass::SHOW_PAGE_ATTRIBUTES).reject{ |a| a == :node }.freeze

  def show_in_sidebar?
    true
  end

end
