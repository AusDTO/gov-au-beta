class Node < ApplicationRecord
  extend FriendlyId, Enumerize
  include Container, Revisable
  friendly_id :name, use: :slugged, routes: :default

  acts_as_tree order: 'order_num ASC'

  belongs_to :section
  has_many :submissions, through: :revisions

  before_create :generate_token
  before_save :ensure_order_num_present

  enumerize :state, in: NodesHelper.states, scope: true

  validates_uniqueness_of :token

  # store_attribute :content, :content_body, String
  content_attribute :content_body

  def ancestry
    arr = [self]

    while ancestor = arr.last.parent
      arr << ancestor
    end

    arr
  end

  def to_s
    self.name
  end

  def path
    path_elements.join('/')
  end

  def path_elements
    ancestry.reverse.collect(&:slug)
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
end

# Ensure we load all of the models so Node.descendants is accurate (probably could namespace these!)
Dir.glob('./app/models/*.rb') { |f| require f }
