class RootProtectionValidator < ActiveModel::Validator
  def validate(node)
    if RootNode.any? && node.type == 'RootNode'
      node.errors.add :type, 'There can only be one root node'
    end
  end
end
