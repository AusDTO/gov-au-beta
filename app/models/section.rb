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

  after_create :generate_home_node

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

  def generate_home_node
    unless home_node.present?
      SectionHome.create do |node|
        node.name = name
        node.slug = name.try(:parameterize)
        node.content_body = ''
        node.section = self
        node.state = 'published'
        node.parent = Node.root
      end
    end
  end
end

%w(agency department minister topic).each do |clazz_file|
  require_dependency clazz_file
end
