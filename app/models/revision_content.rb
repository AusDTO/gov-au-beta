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
    # First get the HEAD
    value = node.send(content_key) || ''

    traversal_sequence.each do |rev|
      if rev.diffs[content_key].present?
        diff = JSON.parse(rev.diffs[content_key])

        value = if revision.applied?
                  value.patch diff   # Patch forward
                else
                  value.unpatch diff # Unpatch backward
                end
      end
    end

    value
  end

  def method_missing(method_sym, *arguments, &block)
    if method_sym.to_s =~ /^content_/ && node.respond_to?(method_sym)
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
    if revision.applied?
      node.revisions.applied.since revision
    else
      node.revisions.pending.until revision
    end
  end
end