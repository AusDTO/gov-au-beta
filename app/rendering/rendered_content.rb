class RenderedContent

  attr_reader :rendered
  alias :content :rendered
  delegate :errors, to: :@template, allow_nil: true

  # While not currently used, node is passed in here because
  #  (a) we may wish to make relevant node fields available in templates (name, summary, etc)
  #  (b) if we ever wish to support rendering one node's content on another node,
  #      we need the node information to ensure we don't enter an infinite loop
  def initialize(node, content, toc_depth)
    @node = node
    @raw = content
    if @raw
      @template = Liquid::Template.parse(@raw)
      @liquid_rendered = @template.render({'nodes' => NodesDrop.new}, exception_handler: ->(e) {render_exception(e)})
      @rendered = MarkdownRenderer.new(toc_depth).content(@liquid_rendered)
    end
  end

  def render_exception(e)
    ViewHelpers.instance.content_tag(:span, Liquid::Error.render(e), class: 'liquid-error')
  end
end