class Revision < ApplicationRecord
  acts_as_tree

  scope :applied, -> { where.not(applied_at: nil).order(:applied_at) }
  scope :pending, -> { where(applied_at: nil).order(:created_at) }
  scope :until, -> (revision) { where('created_at <= ?', revision.created_at) }
  scope :since, -> (revision) { where('applied_at > ?', revision.applied_at) }

  belongs_to :revisable, polymorphic: true
  has_one :submission

  delegate :section, to: :revisable, allow_nil: true

  before_create do
    self.id = SecureRandom.uuid
  end

  def applied?
    applied_at.present?
  end

  def pending?
    applied_at.nil?
  end

  def diffs
    HashWithIndifferentAccess.new(self[:diffs])
  end

  def apply!
    transaction do
      revisable.apply_content RevisionContent.new(self).all_content
      revisable.save
      update applied_at: Time.now
    end
  end
end
