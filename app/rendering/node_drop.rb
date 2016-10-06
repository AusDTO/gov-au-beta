class NodeDrop < Liquid::Drop
  def initialize(node)
    @node = node
  end

  delegate :name, to: :@node
  delegate :short_summary, to: :@node

  def placeholder
    @node.options.placeholder
  end

  def link_to(link_text=nil)
    link_text ||= @node.name
    h = ViewHelpers.instance
    if placeholder
      h.content_tag(:span, link_text, class: 'placeholder-link')
    else
      h.link_to(link_text, path)
    end
  end

  def path
    ViewHelpers.instance.public_node_path(@node)
  end

  # TODO: allow rendering another node's content_body, ensuring no infinite cycles

end