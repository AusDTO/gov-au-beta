module NodesHelper

  MAX_MENU_DEPTH = 4

  def render_node(node)
    section = node.section

    if section.present?
      if section.layout.present?
        render "templates/#{node.template}", layout: section.layout
      else
        render "templates/#{node.template}", layout: 'section'
      end
    else
      render "templates/#{node.template}"
    end
  end

end
