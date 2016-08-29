class Section < ApplicationRecord

  COLLABORATE_CMS = 'Collaborate'

  has_many :nodes
  has_many :requests
  has_many :news_distributions, as: :distribution
  has_many :news_articles, through: :news_distributions
  has_and_belongs_to_many :categories, join_table: :section_categories
  has_one :home_node, class_name: 'SectionHome'

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
    # TODO there has to be a one hit way to get these results
    Section.find_roles.pluck(:name).inject(Array.new) do |result, role|
      result += User.with_role(role, self)
    end.uniq
  end

  def news_node
    # There can only be one ...
    # TODO: select this by NewsAggegator type, once it exists
    nodes.with_name('News').first
  end

  private

  def set_default_cms_type
    self.cms_type ||= COLLABORATE_CMS
  end

  # FIXME: this should be done in a controller to break a circular dependency.
  # Fabricators cannot create a SectionHome which creates a Section which creates a SectionHome!
  # Perhaps a better way is to use a Creator service object (DD)
  def generate_home_node
    unless Rails.env.test?  # <-- added this to avoid breaking specs
      unless home_node.present?
        create_home_node! do |node|
          node.name = name
          node.content_body = ''
          node.section = self
          node.state = 'published'
          node.parent = Node.root_node
        end
      end
    end
  end

  # TODO: add a after_create hook for this method
  # TODO: refactor generate_home_node into this
  def generate_indispensable_nodes
    unless news_node.present?
      # TODO: Create NewsNode
    end
  end
end

%w(agency department minister root_section topic).each do |clazz_file|
  require_dependency clazz_file
end
