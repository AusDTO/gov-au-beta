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

  # n.b. Working assumption is based on a single stream of work: new pending
  #      revision will be based on the most recently created revision
  #      (or just off self if there aren't any pending revisions
  def revise!(revised_contents)
    diffs = revised_contents.collect {|content_key, revised_value|
      current_value = latest_content content_key

      unless send(content_key) == revised_value # Ignore unchanged contents
        [content_key, persistable_diff(current_value, revised_value).to_json]
      end
    }.compact.to_h

    revisions.build(diffs: diffs).tap do |revision|
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

  def latest_content(key)
    base.send(key) || ''
  end

  def base
    @base ||= if revisions.pending.any?
                RevisionContent.new(revisions.pending.last)
              else
                self
              end
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
