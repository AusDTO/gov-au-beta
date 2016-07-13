module MarkdownHelper
  def markdown_content(markdown)
    MarkdownRenderer.new.content(markdown)
  end

  def markdown_toc(markdown, nesting_level = 2)
    MarkdownRenderer.new(nesting_level).toc(markdown)
  end
end