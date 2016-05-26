class NodeDecorator < Draper::Decorator
  delegate_all

  def edit_url
    base_url = Rails.application.config.authoring_base_url
    "#{base_url}/node/#{uuid}/edit"
  end

end