class AssetForm < Reform::Form
  include Reform::Form::ActiveRecord
  property :asset_file
  validates :asset_file, presence: true
end
