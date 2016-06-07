class NodeDecorator < Draper::Decorator
  delegate_all

  def edit_url
    "/editorial/nodes/#{id}/edit"
  end

  def updated_at
    object.updated_at.strftime '%d %b %Y, %I:%M%P'
  end

  def type_display_name
    case self
    when GeneralContent
      'general content'
    when NewsArticle
      'news article'
    else
      'node'
    end
  end

  def template
    object.class.to_s.underscore
  end

end