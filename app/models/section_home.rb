class SectionHome < Node

  validates :parent, ancestry_depth: { equals: 1 }
  validates :section, presence: true, uniqueness: true

  after_save :propagate_name_to_section, only: :name_changed?

  def layout
    'section_home'
  end

  private

  def propagate_name_to_section
    section.update_attribute('name', self.name)
  end
end
