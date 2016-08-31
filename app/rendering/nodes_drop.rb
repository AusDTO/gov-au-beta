class NodesDrop < Liquid::Drop

  def liquid_method_missing(method)
    if uuid?(method)
      node = Node.find_by(token: method)
      return NodeDrop.new(node) if node
    end
    raise "Couldn't find node with id='#{method}'"
  end

  private

  def uuid?(str)
    /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\Z/i.match(str)
  end

end
