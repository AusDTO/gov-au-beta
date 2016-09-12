class Asset < ActiveRecord::Base
  belongs_to :uploader, class_name: "User"

  has_attached_file :asset_file,
                    adapter_options: {hash_digest: Digest::SHA1},
                    styles: {medium: "300x300>", thumb: "125x125>"}
                    # styles resize syntax: https://www.imagemagick.org/Usage/resize/#resize

  validates_attachment :asset_file,
                       presence: true,
                       content_type: {content_type: /\Aimage\/.*\z/},
                       size: {in: 0..5.megabytes}
end