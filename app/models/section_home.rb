class SectionHome < Node

  validates :parent, ancestry_depth: { equals: 1 }
  validates :section, presence: true, uniqueness: true
  validate :parent_not_changed

  after_save :propagate_name_to_section, only: :name_changed?

  def layout
    'section_home'
  end

  def reparentable?
    false
  end

  private

  def propagate_name_to_section
    section.update_attribute('name', self.name)
  end

  def parent_not_changed
    if self.persisted? && parent_id_changed?
      errors.add(:parent_id, "Change of parent not permitted for section home")
    end
  end
end
