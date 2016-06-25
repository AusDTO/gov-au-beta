class Submission < ApplicationRecord

  scope :draft, -> { where reviewed_at: nil }
  scope :unsubmitted, -> { where submitted_at: nil }
  scope :submitted, -> { where.not submitted_at: nil }
  scope :reviewed, -> { where.not reviewed_at: nil }
  scope :accepted, -> { reviewed.where accepted: true }
  scope :rejected, -> { reviewed.where accepted: false }

  belongs_to :revision
  belongs_to :submitter, class_name: 'User'
  belongs_to :reviewer, class_name: 'User'

  delegate :revisable, to: :revision

  validates_presence_of :revision
  validates_presence_of :submitter

  def draft?
    reviewed_at.nil?
  end

  def submitted?
    submitted_at.present?
  end

  def unsubmitted?
    submitted_at.nil?
  end

  def reviewed?
    reviewed_at.present?
  end

  def rejected?
    !accepted?
  end

  def submit!(by_author)
    self.submitted_at = Time.now
    self.submitter = by_author
    save!
  end

  def accept!(by_reviewer)
    transaction do
      review! by_reviewer, true
      revision.apply!
    end
  end

  def reject!(by_reviewer)
    review! by_reviewer, false
  end

  private

  def review!(by_reviewer, accept)
    self.reviewer = by_reviewer
    self.reviewed_at = Time.now
    self.accepted = accept
    save!
  end

end
