class Submission < ApplicationRecord
  extend Enumerize
  enumerize :state, in: %w{draft submitted accepted rejected}, scope: true

  belongs_to :revision
  belongs_to :submitter, class_name: 'User'
  belongs_to :reviewer, class_name: 'User'

  delegate :revisable, to: :revision
  delegate :section, to: :revision

  scope :with_node, -> {
    joins(:revision).joins('INNER JOIN nodes ON nodes.id=revisions.revisable_id').where('revisions.revisable_type=?', 'Node')
  }

  scope :with_published_node, ->{
    with_node.where('nodes.state=?', 'published')
  }


  scope :with_unpublished_node, -> {
    with_node.where('nodes.state!=?', 'published')
  }

  scope :of_section, -> (section) {
    with_node.where('nodes.section_id=?', section.id)
  }

  scope :open_submissions_for, -> (user) {
    where(submitter: user).without_state(:accepted, :rejected).order(updated_at: :desc)
  }

  scope :open, -> {
    without_state(:accepted, :rejected)
  }

  scope :for, -> (user) {
    where(submitter: user).order(updated_at: :desc)
  }

  validates_presence_of :revision
  validates_presence_of :submitter

  def draft?
    self.state == 'draft'
  end

  def submitted?
    self.state == 'submitted'
  end

  def accepted?
    self.state == 'accepted'
  end

  def rejected?
    self.state == 'rejected'
  end

  class StateError < StandardError
  end

  def submit!(by_author)
    if self.state != 'draft'
      raise StateError, 'Submissions can only be made from a draft'
    end
    self.state = 'submitted'
    self.submitted_at = Time.now
    self.submitter = by_author
    save!
  end

  def accept!(by_reviewer)
    if self.state != 'submitted'
      raise StateError, 'Only submitted revisions can be accepted'
    end
    transaction do
      review! by_reviewer, 'accepted'
      revision.apply!
      # For now, as soon as a submission is accepted, the node is published
      # This is subject to change as we update workflow
      revisable.update(state: 'published', published_at: Time.now.utc)
    end
  end

  def reject!(by_reviewer)
    if self.state != 'submitted'
      raise StateError, 'Only submitted revisions can be rejected'
    end
    review! by_reviewer, 'rejected'
  end

  private

  def review!(by_reviewer, state)
    self.reviewer = by_reviewer
    self.reviewed_at = Time.now
    self.state = state
    save!
  end

end
