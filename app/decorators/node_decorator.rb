class NodeDecorator < Draper::Decorator
  delegate_all

  def edit_url
    "/editorial/nodes/#{id}/edit"
  end

  def updated_at
    object.updated_at.strftime '%d %b %Y, %I:%M%P'
  end

  def type_display_name
    I18n.t("domain_model.nodes.#{object.class.name.underscore}")
  end

  def template
    object.class.to_s.underscore
  end

end