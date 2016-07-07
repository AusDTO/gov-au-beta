class Node < ApplicationRecord
  extend FriendlyId, Enumerize
  include Container, Revisable
  friendly_id :name, use: :slugged, routes: :default

  acts_as_tree order: 'order_num ASC'

  belongs_to :section
  has_many :submissions, through: :revisions

  before_create :generate_token, :spawn_initial_revision
  before_save :ensure_order_num_present

  enumerize :state, in: NodesHelper.states, scope: true

  validates_uniqueness_of :token

  # store_attribute :content, :content_body, String
  content_attribute :content_body

  scope :without_parent, -> { where(:parent => nil) }

  scope :published, -> { where(:state => 'published') }

  def to_s
    self.name
  end

  def path
    path_elements.join('/')
  end

  def path_elements
    self_and_ancestors.reverse.collect(&:slug)
  end

  def submission_exists_for?(user)
    self.submissions.open.for(user).present?
  end

  private

  def ensure_order_num_present
    unless order_num.present?
      if parent.present? && parent.children.any?
        self.order_num = parent.children.maximum(:order_num) + 1
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
      revise_from_content(empty_content, self.all_content).tap do |rev|
        rev.applied_at = Time.now
      end
    end
  end

end

# In order for Node.descendants to work, we need to preload the STI classes.
# `require_dependency` is used instead of `require` as it participates in
# hot reloading a development time.
require_dependency 'general_content'
require_dependency 'news_article'
