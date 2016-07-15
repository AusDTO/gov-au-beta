class SectionHeritageValidator < ActiveModel::Validator
  def validate(node)
    if node.parent.present? && node.parent.section.present?
      unless node.section == node.parent.section
        node.errors.add :section, 'Section does not match parent\'s section'
      end
    end
  end
end
