=begin

This validator allows one to test the depth of a hierarchical model e.g. a node.

Assumption is that attribute is the ancestry key (e.g. 'parent').

You need to supply options for this to validate anything at all. Usage examples:

validates :parent, ancestry_depth: { minimum: 1 }
validates :parent, ancestry_depth: { maximum: 5 }
validates :parent, ancestry_depth: { equals: 1 }
validates :parent, ancestry_depth: { minimum: 1, maximum: 3 }

=end

class AncestryDepthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    depth = get_depth record, attribute, 0

    if options[:maximum].present?
      if depth > options[:maximum]
        record.errors.add attribute, options[:message] ||
          "Ancestry depth #{depth} exceeds maximum: #{options[:maximum]}"
      end
    end

    if options[:minimum].present?
      if depth < options[:minimum]
        record.errors.add attribute, options[:message] ||
          "Ancestry depth #{depth} less than minimum: #{options[:minimum]}"
      end
    end

    if options[:equals].present?
      unless depth == options[:equals]
        record.errors.add attribute, options[:message] ||
          "Ancestry depth #{depth} should be #{options[:equals]}"
      end
    end
  end

  private

  def get_depth(record, attribute, depth)
    if record.send(attribute).present?
      depth += 1 + get_depth(record.send(attribute), attribute, depth)
    end

    depth
  end
end
