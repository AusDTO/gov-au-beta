class SectionHome < Node

  validates_presence_of :section, :parent

  validate :child_of_root

  private

  def child_of_root
    if parent.present? && parent.parent.present?
      errors.add :parent, 'Home page of sections must be children of the root node'
    end
  end

end
