class Node < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_tree order: 'order_num ASC'

  belongs_to :section
  belongs_to :template
  has_one :content_block

  before_save :ensure_order_num_present

  validates_uniqueness_of :order_num, scope: :parent_id

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
