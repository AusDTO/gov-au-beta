module NodesHelper

  MAX_MENU_DEPTH = 4

  def render_node(node)
    render "templates/#{node.template}", layout: node.layout
  end

  def set_menu_nodes
    if @section.present? && @section.home_node.present?
      @menu_nodes = @section.home_node.children.published
    end
  end

  def public_node_path(node)
    Rails.application.routes.url_helpers.nodes_path(path: node.path)
  end
end
