module ContentHelper

  def process_html(html)
    html_doc = Nokogiri::HTML(html)

    html_doc.xpath('//a').each do |a|
      if a['data-uuid']
        node = Node.find_by(uuid: a['data-uuid'])

        if node
          a['href'] = nodes_path section: node.section, path: node.path
        end
      end
    end

    html_doc.at('body').children.to_html
  end

end