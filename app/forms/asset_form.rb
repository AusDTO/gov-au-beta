class AssetForm < Reform::Form
  property :asset_file
  validates :asset_file, presence: true
end
