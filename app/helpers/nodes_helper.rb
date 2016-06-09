module NodesHelper

  def render_node(node, section)
    if section.layout.present?
      render "templates/#{node.template}", layout: section.layout
    else
      render "templates/#{node.template}"
    end
  end

  def self.states
    %w{draft published}
  end
  
end