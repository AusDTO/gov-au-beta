class NodeCompiler
  def initialize(node)
    @node = node
  end

  def body
    template = Liquid::Template.parse(@node.content_body)
    compiled = template.render('data' => data)
    puts @node.content_body
    MarkdownRenderer.new.content(compiled).html_safe
  end

  def data
    return @node.data_bundles.first.data
    {}.tap do |hash|
      @node.data_bundles.each do |bundle|
        hash.merge!(bundle.data)
      end
    end
  end
end
