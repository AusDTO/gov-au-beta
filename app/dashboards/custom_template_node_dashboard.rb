require "administrate/base_dashboard"

class CustomTemplateNodeDashboard < NodeDashboard
  ATTRIBUTE_TYPES = {
      template: Field::String,
  }.update(self.superclass::ATTRIBUTE_TYPES).freeze

  SHOW_PAGE_ATTRIBUTES = (self.superclass::SHOW_PAGE_ATTRIBUTES + [
      :template,
  ]).freeze

  FORM_ATTRIBUTES = (self.superclass::FORM_ATTRIBUTES + [
      :template
  ]).freeze

  def show_in_sidebar?
    true
  end
end
