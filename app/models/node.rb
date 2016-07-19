class Node < ApplicationRecord
  extend FriendlyId, Enumerize
  include Container, Revisable
  friendly_id :name, use: [:slugged, :scoped], routes: :default, scope: :parent

  STATES = %w{draft published}

  acts_as_tree order: 'order_num ASC'

  scope :with_sectionless_parent, -> {
    includes(:parent).
    joins(:parent).
    where('parents_nodes.section_id IS NULL') }

  scope :published, -> { where state: 'published' }

  belongs_to :section
  has_many :submissions, through: :revisions

  enumerize :state, in: STATES, scope: true
  content_attribute :content_body
  content_attribute :name
  # options is not currently versioned but could be in the future
  store_attribute :content, :options

  around_create :spawn_initial_revision
  before_validation :generate_token
  before_save :ensure_order_num_present

  validates :parent, non_recursive_ancestry: true
  validates_with RootProtectionValidator
  validates_uniqueness_of :token

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

  # Override in subclasses to add options
  # Format is {option: :default_value}
  def available_options
    {}
  end

  # 1) reform requires options to be an object with attributes
  # 2) activerecord wants it to be a hash
  # 3) Storext's default type coercion doesn't work properly with OpenStruct
  # so for now, we just do the conversion by hand
  def options
    hash = super
    if hash
      OpenStruct.new(hash)
    else
      OpenStruct.new(available_options)
    end
  end

  def options=(value)
    super(value.to_h)
  end

  # See http://norman.github.io/friendly_id/file.Guide.html#Deciding_When_to_Generate_New_Slugs
  def should_generate_new_friendly_id?
    # Note: x_changed? refers to the column x not the accessor method
    name.present? && (content_changed? || parent_id_changed? || super)
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
end

# In order for Node.descendants to work, we need to preload the STI classes.
# `require_dependency` is used instead of `require` as it participates in
# hot reloading a development time.
%w(general_content news_article root_node section_home).each do |clazz_file|
  require_dependency clazz_file
end
