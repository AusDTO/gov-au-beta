class MarkdownRenderer
  def initialize(nesting_level = 2)
    @content_renderer = Redcarpet::Markdown.new(::ContentMarkdown, tables: true)
    # TODO: uikit does not yet support nested TOC
    # Once they do, revisit the nesting_level option
    # See https://github.com/AusDTO/gov-au-ui-kit/issues/164
    @toc_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC.new(nesting_level: nesting_level))
  end

  def content(markdown_content)
    render(@content_renderer, markdown_content)
  end

  def toc(markdown_content)
    render(@toc_renderer, markdown_content)
  end

  private

  def render(renderer, markdown_content)
    unless markdown_content.nil?
      raw = renderer.render(markdown_content)
      ActionController::Base.helpers.sanitize(raw)
    end
  end
end