module NodesHelper

  MAX_MENU_DEPTH = 4

  def render_node(node, section)
    if section.layout.present?
      render "templates/#{node.template}", layout: section.layout
    else
      render "templates/#{node.template}"
    end
  end

  def root_nodes(section)
    section.nodes.where(:parent => nil).decorate
  end

  def self.states
    %w{draft published}
  end
  
end
