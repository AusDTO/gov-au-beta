class Section < ApplicationRecord
  has_many :nodes
  has_many :requests

  has_and_belongs_to_many :sections,
        class_name: 'Section',
        join_table: :section_connections,
        foreign_key: :section_id,
        association_foreign_key: :connection_id

  validates :name, uniqueness: { case_sensitive: false }

  # Note: resourcify must be called in every subclass so rolify will work
  resourcify

  after_initialize :set_default_cms_type

  # Finds the users with a role on this Section
  def users
    Section.find_roles.pluck(:name).inject(Array.new) do |result, role|
      result += User.with_role(role, self)
    end.uniq
  end

  def find_by_slug(slug)
    Section.find_by(slug: slug)
  end

  def home_node
    nodes.with_sectionless_parent.first
  end

  private

  def set_default_cms_type
    self.cms_type ||= "Collaborate"
  end
end

require_dependency 'agency'
require_dependency 'department'
require_dependency 'topic'
