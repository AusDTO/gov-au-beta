class NodeDecorator < Draper::Decorator
  delegate_all
  decorates_association :submissions
  decorates_association :children

  def type_display_name
    I18n.t("domain_model.nodes.#{object.class.name.underscore}")
  end

  def template
    object.class.to_s.underscore
  end

  def published_children
    object.children.with_state(:published).order(:name).decorate
  end
end
