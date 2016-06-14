class Section < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :nodes
  # Make Section look like a node
  alias_attribute :children, :nodes

  validates :name, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: { case_sensitive: false }

  # Finds a node via path from this Section.
  def find_node!(path)
    path.split('/').reduce(self) do |node,slug|
      node.children.find_by! slug: slug
    end
  end
end
