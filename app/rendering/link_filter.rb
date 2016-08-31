module LinkFilter

  def link_to_node(link_text, node)
    raise 'invalid node' unless node.is_a?(NodeDrop)
    node.link_to(link_text)
  end

  def placeholder_link(link_text)
    ViewHelpers.instance.content_tag(:span, link_text, class: 'placeholder-link')
  end

end