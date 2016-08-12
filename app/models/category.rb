class Category < ApplicationRecord
  acts_as_tree

  extend FriendlyId
  friendly_id :name, use: [:slugged]

  has_and_belongs_to_many :sections, join_table: :section_categories

  def to_s
    self.name
  end
end
