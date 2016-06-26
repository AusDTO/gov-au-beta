require 'diff/lcs/string'

class RevisionContent

  attr_reader :revision

  def initialize(revision)
    @revision = revision
  end

  def all_content
    node.all_content.collect {|key, _value|
      [key, get_content(key)]
    }.to_h
  end

  def get_content(content_key)
    value = ''

    traversal_sequence.each do |rev|
      if rev.diffs[content_key].present?
        diff = JSON.parse(rev.diffs[content_key])
        value = value.patch diff
      end
    end

    value
  end

  def method_missing(method_sym, *arguments, &block)
    if node.class.content_attributes.include? method_sym
      get_content(method_sym)
    else
      super
    end
  end

  private

  def node
    revision.revisable
  end

  def traversal_sequence
    revision.self_and_ancestors.reverse
  end
end
