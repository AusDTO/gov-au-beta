require "administrate/base_dashboard"

class AgencyDashboard < SectionDashboard

  ATTRIBUTE_TYPES = {
      # The import govcms button needs to know the CMS type and the object id
      # We use #itself here so the views can see the entire object
      itself: ImportGovcmsField,
  }.update(self.superclass::ATTRIBUTE_TYPES).freeze

  COLLECTION_ATTRIBUTES = (self.superclass::COLLECTION_ATTRIBUTES + [
      :itself,
  ]).freeze

  SHOW_PAGE_ATTRIBUTES = (self.superclass::SHOW_PAGE_ATTRIBUTES + [
      :itself,
  ]).reject{|a| a == :node}.freeze

  def show_in_sidebar?
    true
  end

end
