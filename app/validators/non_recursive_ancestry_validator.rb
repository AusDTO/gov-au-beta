class NonRecursiveAncestryValidator < ActiveModel::Validator
  def validate(record)
    node = record

    while node.parent
      node = node.parent

      if node == record
        record.errors.add :parent, 'Circular ancestry is invalid'
        return
      end
    end
  end
end
