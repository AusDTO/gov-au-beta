class MarkdownRenderer
  # http://kramdown.gettalong.org/converter/html.html#toc
  TOC_HEADER = "* TOC\n{:toc}\n\n"

  def initialize(nesting_level)
    @content_renderer = Kramdown::Document
    @toc_depth = nesting_level || 1

    # TODO: uikit does not yet support nested TOC
    # Once they do, revisit the nesting_level option
    # See https://github.com/AusDTO/gov-au-ui-kit/issues/164
    # If a TOC needs to be rendered separate of content, revisit the approach below
    # @toc_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC.new(nesting_level: nesting_level))
  end


  def content(markdown_content)
    render(@content_renderer, markdown_content)
  end


  private
  def render(renderer, markdown_content)
    unless markdown_content.nil?

      # Prepend the TOC markdown so that kramdown expands
      # it at the top of the document. We should always inject this, as the
      # @toc_depth indicates the range  of the TOC which defaults to rendering
      # nothing.
      raw = renderer.new(TOC_HEADER + markdown_content, {
        input: 'kramdown',
        toc_levels: "1..#{@toc_depth + 1}",
        smart_quotes: ["apos", "apos", "quot", "quot"]
      }).to_govau_html.html_safe

      # We should perhaps sanitize the raw markdown_content, rather than
      # the output from our renderer.
      ActionController::Base.helpers.sanitize(raw)
    end
  end
end