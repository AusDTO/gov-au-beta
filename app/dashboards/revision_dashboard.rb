require "administrate/base_dashboard"

class RevisionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    parent: Field::BelongsTo.with_options(class_name: "Revision"),
    children: Field::HasMany.with_options(class_name: "Revision"),
    revisable: Field::Polymorphic,
    submission: Field::HasOne,
    id: Field::String.with_options(searchable: false, truncate: 8),
    diffs: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    applied_at: Field::DateTime,
    parent_id: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :parent,
    :revisable,
    :submission,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :parent,
    :children,
    :revisable,
    :submission,
    :diffs,
    :created_at,
    :applied_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    # This model is read only
  ].freeze

  # Overwrite this method to customize how revisions are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(revision)
    "Revision ##{revision.id[0...8]}..."
  end

  # Overwrite this method to customize whether the index page for revisions 
  # is included in the sidebar.
  #
  # def show_in_sidebar?
  #   true
  # end
end
