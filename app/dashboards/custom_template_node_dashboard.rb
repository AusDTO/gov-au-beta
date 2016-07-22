require "administrate/base_dashboard"

class CustomTemplateNodeDashboard < NodeDashboard

  def self.template_options
    Dir.glob('app/views/templates/custom/*').map do |filename|
      filename[Regexp.new('app/views/templates/(.*)\.html\..*'), 1]
    end
  end

  ATTRIBUTE_TYPES = {
      template: Field::Select.with_options(collection: template_options),
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
