require "administrate/base_dashboard"

class AssetDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
      id: Field::Number,
      uploader: Field::HasOne,
      asset_file_file_name: Field::String,
      asset_file_content_type: Field::String,
      asset_file_file_size: Field::String,
      asset_file_updated_at: Field::String,
      asset_file_meta: Field::String,
      asset_file_fingerprint: Field::String,
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
      :asset_file_file_name,
      :created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
      :id,
      :uploader,
      :asset_file_file_name,
      :asset_file_content_type,
      :asset_file_file_size,
      :asset_file_updated_at,
      :asset_file_meta,
      :asset_file_fingerprint,
      :created_at,
      :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
      :id,
      :uploader,
      :created_at,
      :updated_at,
  ].freeze
end