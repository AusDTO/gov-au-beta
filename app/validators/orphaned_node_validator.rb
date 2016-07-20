class OrphanedNodeValidator < ActiveModel::Validator
  def validate(node)
    unless node.parent.present?
      node.errors.add :parent, 'Nodes must have parents'
    end
  end
end