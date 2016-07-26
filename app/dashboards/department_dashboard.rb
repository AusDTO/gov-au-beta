require "administrate/base_dashboard"

class DepartmentDashboard < SectionDashboard

  ATTRIBUTE_TYPES = {
      ministers: Field::HasMany.with_options(class_name: 'Minister'),
  }.update(self.superclass::ATTRIBUTE_TYPES).freeze

  SHOW_PAGE_ATTRIBUTES = (self.superclass::SHOW_PAGE_ATTRIBUTES + [
      :ministers,
  ]).reject{|a| a == :node}.freeze

  FORM_ATTRIBUTES = (self.superclass::FORM_ATTRIBUTES + [
      :ministers,
  ]).reject{|a| a == :node}.freeze

  def show_in_sidebar?
    true
  end
end
