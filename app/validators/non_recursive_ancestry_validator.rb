=begin

This is a validator for hierarchies to prevent circular ancestry - i.e. where
the child of a node is also a parent.

Usage example:

validates :parent, non_recursive_ancestry: true

=end
class NonRecursiveAncestryValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    node = record

    while node = node.send(attribute)
      if node == record
        record.errors.add attribute, 'Circular ancestry is invalid'
        return
      end
    end
  end
end
