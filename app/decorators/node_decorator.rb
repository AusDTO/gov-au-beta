class NodeDecorator < Draper::Decorator
  delegate_all

  def edit_url
    base_url = "/nodes/#{id}/edit"
  end

end