# for more details, see https://github.com/vmg/redcarpet
class ContentMarkdown < Redcarpet::Render::HTML
  include ActionView::Helpers::TagHelper

  def initialize(extensions = {})
    super(extensions.merge(with_toc_data: true))
  end

  # override the table method to add custom class
  # super: https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/html.c#L531
  def table(header, body)
    "<table class=\"content-table\"><thead>\n#{header}</thead><tbody>\n#{body}</tbody></table>\n"
  end

  # override the link method to replace # links with placeholder-link spans
  # super: https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/html.c#L327
  def link(link, title, content)
    if link == "#"
      content_tag(:span, content, {:class => "placeholder-link", :title => title})
    else
      #To avoid escaping apostrophes and img links in content, we must disable escaping
      content_tag(:a, content, {:href => link, :title => title}, escape = false)
    end
  end
end