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

  # Note: this returns active first and root last
  def menu_active_chain(active)
    if active
      active.self_and_ancestors.reject{|n| n.options.suppress_in_nav}
    else
      []
    end
  end

  def menu_node_class(node, active_chain)
    return 'is-active is-current' if node == active_chain.first
    return 'is-active' if active_chain.include?(node)
  end

  def public_node_path(node, opts = {})
    opts[:path] = node.path
    Rails.application.routes.url_helpers.nodes_path opts
  end
end
