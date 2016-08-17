class Category < ApplicationRecord
  resourcify

  acts_as_tree counter_cache: :children_count

  extend FriendlyId
  friendly_id :name, use: :slugged, routes: :default

  has_and_belongs_to_many :sections, join_table: :section_categories

  def to_s
    self.name
  end
end
