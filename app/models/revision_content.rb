require 'diff/lcs/string'

class RevisionContent

  attr_reader :revision

  def initialize(revision)
    @revision = revision
  end

  def all_content
    node.all_content.inject({}) do |hash, key_value|
      key = key_value[0]
      content = get_content(key)
      unless content.nil?
        hash[key] = content
      end
      hash
    end
  end

  def get_content(content_key)
    return nil unless traversal_sequence.any? { |rev| rev.diffs[content_key].present? }

    value = ''
    traversal_sequence.each do |rev|
      if rev.diffs[content_key].present?
        diff = JSON.parse(rev.diffs[content_key])
        # n.b. LCS::Diff#patch! *must* be used here rather than the bang-less
        #      #patch method. The former simply applies the patch whereas the
        #      latter attempts auto-discovery to determine whether to patch
        #      or unpatch (and sometimes it gets it wrong = disaster).
        #      Ref: http://www.rubydoc.info/github/halostatue/diff-lcs/Diff/LCS
        value = value.patch! diff
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
