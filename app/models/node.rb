class Node < ApplicationRecord
  extend FriendlyId, Enumerize
  friendly_id :name, use: :slugged, routes: :default

  acts_as_tree order: 'order_num ASC'

  belongs_to :section
  has_one :content_block, autosave: true

  before_create :generate_token
  before_save :ensure_order_num_present

  enumerize :state, in: NodesHelper.states, scope: true

  validates_uniqueness_of :token

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
    ancestry.reverse.collect { |node|
      node.slug
    }.join '/'
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
