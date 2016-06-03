class NodeDecorator < Draper::Decorator
  delegate_all

  def edit_url
    "/editorial/nodes/#{id}/edit"
  end

  def updated_at
    object.updated_at.strftime '%d %b %Y, %I:%M%P'
  end

end