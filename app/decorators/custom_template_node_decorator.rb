class CustomTemplateNodeDecorator < NodeDecorator
  # allow the node to specify its own template
  def template
    object.template
  end
end