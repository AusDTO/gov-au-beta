class RootProtectionValidator < ActiveModel::Validator
  def validate(node)
    if Node.roots.any? && node.parent.nil?
      node.errors.add :parent, 'There can only be one root node'
    end
  end
end
