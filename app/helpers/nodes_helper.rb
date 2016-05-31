module NodesHelper

  def find_node!(section, nodes_path)
    node = nil

    nodes_path.split('/').each_with_index do |slug, idx|
      if node.nil? && idx.zero?
        node = section.nodes.find_by! slug: slug
      else
        node = node.children.find_by! slug: slug
      end
    end

    node
  end
  
end