# for more details, see https://github.com/vmg/redcarpet
class ContentMarkdown < Redcarpet::Render::HTML

  def initialize(extensions = {})
    super(extensions.merge(with_toc_data: true))
  end

  # override the table method to add custom class
  # super: https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/html.c#L531
  def table(header, body)
    "<table class=\"content-table\"><thead>\n#{header}</thead><tbody>\n#{body}</tbody></table>\n"
  end

end