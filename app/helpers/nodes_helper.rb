module NodesHelper

  def find_node!(section, nodes_path)
    node = nil

    nodes_path.split('/').each_with_index do |slug, idx|
      if node.nil? && idx.zero?
        node = section.nodes.with_state(:published).find_by! slug: slug
      else
        node = node.children.with_state(:published).find_by! slug: slug
      end
    end

    node
  end

  def render_node(node, section)
    if section.layout.present?
      render "templates/#{node.template}", layout: section.layout
    else
      render "templates/#{node.template}"
    end
  end
  
end