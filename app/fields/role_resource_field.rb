require "administrate/field/polymorphic"

# Administrate::Field::Polymorphic does not currently support forms so this
# adds support for our specific use case
# Roughly based on Administrate::Field::BelongsTo
class RoleResourceField < Administrate::Field::Polymorphic

  def self.form_name
    'resource_type_and_id'
  end

  def self.permitted_attribute(attr)
    form_name
  end

  def associated_resource_options
    [nil] + candidate_resources.map do |resource|
      [display_candidate_resource(resource), id_for(resource)]
    end
  end

  def selected_option
    data && id_for(data)
  end

  private

  def candidate_resources
    Section.all
  end

  def display_candidate_resource(resource)
    dashboard_of(resource.class).display_resource(resource)
  end

  def dashboard_of(klass)
    "#{klass.name.singularize.camelcase}Dashboard".constantize.new
  end

  def id_for(resource)
    "#{resource.class}-#{resource.id}"
  end

end
