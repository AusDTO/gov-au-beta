require "administrate/base_dashboard"

class RequestDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    user: Field::BelongsTo,
    section: Field::BelongsTo,
    approver: Field::BelongsTo.with_options(class_name: "User"),
    approver_id: Field::Number,
    state: Field::String,
    message: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :user,
    :section,
    :state,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :user,
    :section,
    :state,
    :message,
    :approver,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    # This model is read only
  ].freeze

  # Overwrite this method to customize how requests are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(request)
  #   "Request ##{request.id}"
  # end

  # Overwrite this method to customize whether the index page for requests 
  # is included in the sidebar.
  #
  # def show_in_sidebar?
  #   true
  # end
end
