require "administrate/base_dashboard"

class SubmissionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    revision: Field::BelongsTo,
    submitter: Field::BelongsTo.with_options(class_name: "User"),
    reviewer: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    submitter_id: Field::Number,
    reviewer_id: Field::Number,
    summary: Field::Text,
    submitted_at: Field::DateTime,
    reviewed_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    state: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :revision,
    :submitter,
    :state,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :revision,
    :submitter,
    :reviewer,
    :summary,
    :state,
    :submitted_at,
    :reviewed_at,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    # This model is read only
  ].freeze

  # Overwrite this method to customize how submissions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(submission)
  #   "Submission ##{submission.id}"
  # end

  # Overwrite this method to customize whether the index page for submissions 
  # is included in the sidebar.
  #
  # def show_in_sidebar?
  #   true
  # end
end
