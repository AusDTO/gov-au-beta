 require "administrate/base_dashboard"

class CategoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
      id: Field::Number,
      name: Field::String,
      slug: Field::String,
      short_summary: Field::String,
      summary: Field::String,
      parent: Field::BelongsTo.with_options(class_name: "Category"),
      children: Field::HasMany.with_options(class_name: "Category"),
      sections: Field::HasMany,
      created_at: Field::DateTime,
      updated_at: Field::DateTime,
      placeholder: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
      :id,
      :name,
      :parent,
      :placeholder
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
      :id,
      :name,
      :slug,
      :short_summary,
      :summary,
      :parent,
      :children,
      :sections,
      :created_at,
      :updated_at,
      :placeholder
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
      :name,
      :short_summary,
      :summary,
      :parent,
      :placeholder
  ].freeze


  # Overwrite this method to customize how sections are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(category)
    category.name
  end
end
