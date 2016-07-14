class Node < ApplicationRecord
  extend FriendlyId, Enumerize
  include Container, Revisable
  friendly_id :name, use: :slugged, routes: :default

  STATES = %w{draft published}

  acts_as_tree order: 'order_num ASC'

  scope :with_sectionless_parent, -> {
    includes(:parent).
    joins(:parent).
    where('parents_nodes.section_id IS NULL') }

  scope :published, -> { where state: 'published' }

  belongs_to :section
  has_many :submissions, through: :revisions

  around_create :spawn_initial_revision

  before_validation :inherit_section, :generate_token

  before_save :ensure_order_num_present

  enumerize :state, in: STATES, scope: true

  validates_uniqueness_of :token
  validate :section_heritage, :protect_root, :protect_section_home,
    :ensure_section_presence

  content_attribute :content_body
  content_attribute :name

  def self.find_by_path!(path)
    path.split('/').reject(&:empty?).reduce(Node.root) do |node, slug|
      node.children.find_by! slug: slug
    end
  end

  def to_s
    self.name
  end

  def path
    # n.b. root node has blank path element
    path_elements.reject(&:blank?).join('/')
  end

  def submission_exists_for?(user)
    self.submissions.open.for(user).present?
  end

  private

  def path_elements
    self_and_ancestors.reverse.collect(&:slug)
  end

  def ensure_order_num_present
    unless order_num.present?
      if parent.present? && parent.children.any?
        self.order_num = (parent.children.maximum(:order_num) || 0) + 1
      else
        self.order_num = 0
      end
    end
  end

  def generate_token
    self.token = SecureRandom.uuid unless token.present?
  end

  def spawn_initial_revision
    if content.values.reject(&:blank?).present?
      empty_content = self.class.new
      revision = revise_from_content(empty_content, self.all_content).tap do |rev|
        rev.applied_at = Time.now
      end
      yield
      revision.revisable = self # Once it has an ID
      revision.save
    else
      yield
    end
  end

  def inherit_section
    if section.nil? && parent.present? && parent.section.present?
      self.section = parent.section
    end
  end

  def section_heritage
    if parent.present? && parent.section.present?
      unless section == parent.section
        errors.add :section, 'Section does not match parent\'s section'
      end
    end
  end

  def protect_root
    if parent.nil? && Node.roots.any?
      errors.add :parent, 'There can only be one root node'
    end
  end

  def protect_section_home
    if section.try(:home_node).present? &&
        parent.present? &&
        parent.section.nil? &&
        section.home_node != self
      errors.add :section, 'A section can only have one home node'
    end
  end

  def ensure_section_presence
    if parent.present? && section.nil?
      errors.add :section, 'All nodes except root should have a section'
    end
  end
end

# In order for Node.descendants to work, we need to preload the STI classes.
# `require_dependency` is used instead of `require` as it participates in
# hot reloading a development time.
%w(general_content news_article root_node section_home).each do |clazz_file|
  require_dependency clazz_file
end
