require "administrate/base_dashboard"

class SectionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    nodes: Field::HasMany,
    id: Field::Number,
    type: Field::String,
    name: Field::String,
    slug: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    layout: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :nodes,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :nodes,
    :slug,
    :created_at,
    :updated_at,
    :layout,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :layout,
  ].freeze

  # Overwrite this method to customize how sections are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(section)
    section.name
  end

  def show_in_sidebar?
    false
  end
end
