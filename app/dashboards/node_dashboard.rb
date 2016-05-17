require "administrate/base_dashboard"

class NodeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    parent: Field::BelongsTo.with_options(class_name: "Node"),
    children: Field::HasMany.with_options(class_name: "Node"),
    section: Field::BelongsTo,
    content_block: Field::HasOne,
    id: Field::Number,
    parent_id: Field::Number,
    template: Field::String,
    name: Field::String,
    slug: Field::String,
    order_num: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    uuid: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :section,
    :name,
    :parent,
    :children,
    :template,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :section,
    :name,
    :parent,
    :children,
    :content_block,
    :parent_id,
    :template,
    :slug,
    :order_num,
    :created_at,
    :updated_at,
    :uuid,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
  ].freeze

  # Overwrite this method to customize how nodes are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(node)
    node.name
  end

  def show_in_sidebar?
    false
  end
end
