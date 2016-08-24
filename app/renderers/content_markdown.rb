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

  #SPIKE - Investigate ways to identify broken or missing links
  def postprocess(full_document)
    puts "Redcarpet.postprocess"
    puts "Original html"
    puts full_document
    html = Nokogiri::HTML(full_document)
    links = html.css('a')
    link_checker = LinkChecker.new
    invalid_links = links.to_a.delete_if do |link|
      #Trim out all the private (i.e. editorial), and external links
      #so we will only check the internal public links.
      href = link.attribute('href').to_s
      if link_checker.private_route? href
        return true
      end
      if link_checker.external_link? href
        return true
      end

      link_checker.valid_internal_link? href
    end

    invalid_links.each do |invalid_link|
      puts "Replacing invalid link with placeholder: #{invalid_link}"
      invalid_link.add_next_sibling "<span class='placeholder-link'>#{invalid_link.text}</span>"
      invalid_link.remove
    end

    puts "After postprocess:"
    puts html.to_html
    html.to_html
  end

end