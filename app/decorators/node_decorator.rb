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

  def name
    if object.name.blank?
      '[no name]'
    else
      "#{object.name}"
    end
  end

  # Note: The result of #rendered is cached and will not reflect changes to the content.
  # If this becomes a problem, revisit how this function works.
  def rendered
    unless @rendered
      @rendered = {}
      renderable_fields.each do |field|
        @rendered[field] = RenderedContent.new(object, object.send(field))
      end
    end
    @rendered
  end

  protected

  # Override in subclass to render additional fields
  def renderable_fields
    [:content_body, :summary]
  end

end
