require "administrate/base_dashboard"

class NewsArticleDashboard < NodeDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
      release_date: Field::DateTime,
  }.update(self.superclass::ATTRIBUTE_TYPES).freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = (self.superclass::COLLECTION_ATTRIBUTES + [
      :release_date,
  ]).freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = (self.superclass::SHOW_PAGE_ATTRIBUTES + [
      :release_date
  ]).freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = (self.superclass::FORM_ATTRIBUTES + [
      :release_date
  ]).freeze

  # Overwrite this method to customize whether the index page for general contents
  # is included in the sidebar.
  #
  def show_in_sidebar?
    true
  end
end
