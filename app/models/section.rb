class Section < ApplicationRecord
  include Sluggable

  has_many :nodes

  validates :name, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: { case_sensitive: false }

end
