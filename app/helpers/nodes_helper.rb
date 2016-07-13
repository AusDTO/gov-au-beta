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

  def set_menu_nodes
    if @section.present? && @section.home_node.present?
      @menu_nodes = @section.home_node.children.published
    end
  end

end
