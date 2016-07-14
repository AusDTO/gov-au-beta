module MarkdownHelper
  def markdown_to_html(markdown)
    MarkdownRenderer.new.render(markdown)
  end
end