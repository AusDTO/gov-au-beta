=begin

This module allows for revisions to be created from instances of including
classes (currently, only Node and its descendants).

The #revise! method allows you to create a revision, which is immediately
persisted in the database (but not yet applied - see Revision#apply!)

=end

module Revisable
  extend ActiveSupport::Concern

  included do
    has_many :revisions, as: :revisable
  end

  def revise!(revised_contents)
    if revisions.applied.any?
      revise_from_revision!(revisions.applied.last, revised_contents)
    else
      revise_from_content(self, revised_contents).tap do |revision|
        revision.save!
      end
    end
  end

  def revise_from_revision!(base_revision, revised_contents)
    base_content = RevisionContent.new(base_revision)
    revise_from_content(base_content, revised_contents).tap do |revision|
      revision.parent = base_revision
      revision.save!
    end
  end

  # Get a diff that can be stored as a JSON string, persisted and retrieved
  # to apply (by default, Diff::LCS::Change#as_json isn't very useful)
  def persistable_diff(a, b)
    diff = Diff::LCS.diff a, b
    reify_diff_element(diff).as_json
  end

  private

  # Create a Revision using revised content compared to base content
  def revise_from_content(base_content, revised_content)
    revisions.build(diffs: generate_diff_hash(base_content, revised_content))
  end

  # Generate the hash of diffs to populate a Revision
  def generate_diff_hash(base_content, revised_content)
    revised_content.compact.collect {|content_key, revised_value|
      current_value = base_content.send(content_key) || ''

      # Ignore unchanged contents or nil (not blank!) content attributes
      unless current_value == revised_value
        [content_key, persistable_diff(current_value, revised_value || '').to_json]
      end
    }.compact.to_h
  end

  # This is a bit gross, but I didn't want to monkey-patch Diff::LCS::Change
  def reify_diff_element(element)
    case element
      when Array
        element.collect do |el|
          reify_diff_element el
        end
      when Diff::LCS::Change
        element.to_a
      else
        element
    end
  end
end
