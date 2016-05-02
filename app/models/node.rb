class Node < ApplicationRecord
  include Sluggable

  belongs_to :section
  belongs_to :template
  belongs_to :parent_node, class_name: 'Node'
  has_many :child_nodes, class_name: 'Node', foreign_key: 'parent_node_id'
  has_one :content_block

  delegate :name, to: :content_block

end
