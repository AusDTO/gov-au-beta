require "administrate/base_dashboard"

class AgencyDashboard < SectionDashboard

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :summary,
    :slug,
    :created_at,
    :updated_at,
    :layout,
    :cms_type,
    :cms_url,
    :cms_path,
  ].freeze

  def show_in_sidebar?
    true
  end

end
