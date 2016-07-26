class Section < ApplicationRecord

  COLLABORATE_CMS = 'Collaborate'

  has_many :nodes
  has_many :requests
  has_many :news_distributions, as: :distribution
  has_many :news_articles, through: :news_distributions

  has_and_belongs_to_many :sections,
        class_name: 'Section',
        join_table: :section_connections,
        foreign_key: :section_id,
        association_foreign_key: :connection_id

  delegate :slug, to: :home_node, allow_nil: true

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

  def home_node
    nodes.with_sectionless_parent.first
  end

  # we can't use delegate :name, to home_node because we have to create the Section before the SectionHome
  # we can't have the SectionHome delegate :name to the section because that doesn't work with the revisable system
  # So manually override name to delegate to the home_node if it exists
  def name
    if home_node
      home_node.name
    else
      super
    end
  end

  private

  def set_default_cms_type
    self.cms_type ||= COLLABORATE_CMS
  end

  def generate_home_node
    unless home_node.present?
      SectionHome.create! do |node|
        node.name = name
        node.content_body = ''
        node.section = self
        node.state = 'published'
        node.parent = Node.root_node
      end
    end
  end
end

%w(agency department minister topic).each do |clazz_file|
  require_dependency clazz_file
end
