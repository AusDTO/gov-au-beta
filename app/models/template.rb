class Template < ApplicationRecord
  include Sluggable

  attachment :preview_image

  validates :name, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: { case_sensitive: false }

end
