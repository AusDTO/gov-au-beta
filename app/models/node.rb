class Node < ApplicationRecord
  extend FriendlyId, Enumerize
  friendly_id :name, use: :slugged, routes: :default

  acts_as_tree order: 'order_num ASC'

  belongs_to :section
  has_one :content_block

  before_save :ensure_order_num_present

  enumerize :state, in: %w(draft published)

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

  def full_path
    "/#{section.slug}/#{path}"
  end

  def default_form
    NodeForm.new(self)
  end

  def template
    'default'
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

end
