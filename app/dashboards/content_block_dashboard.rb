require "administrate/base_dashboard"

class ContentBlockDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    node: Field::BelongsTo,
    id: Field::Number,
    body: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    unique_id: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :node,
    :id,
    :body,
    :created_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :node,
    :id,
    :body,
    :created_at,
    :updated_at,
    :unique_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :body,
    :unique_id,
  ].freeze

  # Overwrite this method to customize how content blocks are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(content_block)
  #   "ContentBlock ##{content_block.id}"
  # end

  def show_in_sidebar?
    false
  end
end
