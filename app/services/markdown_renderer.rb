class MarkdownRenderer
  def initialize
    @renderer = Redcarpet::Markdown.new(::ContentMarkdown, tables: true)
  end

  def render(markdown_content)
    unless markdown_content.nil?
      raw = @renderer.render(markdown_content)
      ActionController::Base.helpers.sanitize(raw)
    end
  end
end