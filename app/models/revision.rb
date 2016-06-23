class Revision < ApplicationRecord
  belongs_to :revisable, polymorphic: true
  scope :applied, -> { where.not(applied_at: nil).order(applied_at: :desc) }
  scope :pending, -> { where(applied_at: nil).order(:created_at) }
  scope :until, -> (revision) { where('created_at <= ?', revision.created_at) }
  scope :since, -> (revision) { where('applied_at > ?', revision.applied_at) }

  def applied?
    applied_at.present?
  end

  def pending?
    applied_at.nil?
  end

  def diffs
    self[:diffs].symbolize_keys
  end

  def apply!
    transaction do
      revisable.apply_content RevisionContent.new(self).all_content
      revisable.save
      update applied_at: Time.now
    end
  end
end
