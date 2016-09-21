class AssetForm < Reform::Form
  property :alttext
  property :asset_file
  validates :asset_file, presence: true
end
