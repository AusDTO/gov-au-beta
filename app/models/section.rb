class Section < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :nodes

  validates :name, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: { case_sensitive: false }

  def to_s
    self.name
  end
end
