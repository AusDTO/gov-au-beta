class Template < ApplicationRecord

  attachment :preview_image

  validates :name, uniqueness: { case_sensitive: false }
end
