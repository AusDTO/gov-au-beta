class LinkChecker

  # Check this a valid internal link i.e. a link to the site where the destination exists.
  # It is intended this is used somewhere like the markdown renderer where it is not
  # feasible to do a GET. Instead, the route is examined to select the relevant controller,
  # and we search the database with the slug.
  def valid_internal_link? href

    if !valid_uri? href
      return false
    end

    raise "external links not supported" unless !external_link? href

    #TODO do we need to support private routes?
    raise "private routes not yet supported" unless !private_route? href

    path = URI(href).path

    result = Rails.application.routes.recognize_path(path, :method => :get)

    puts "controller=#{result[:controller]}"

    begin
      if result[:controller] == 'nodes'
        path = URI(href).path
        if Node.find_by_path! path
          #We found a Node, so it's a valid link
          return true
        end
      elsif result[:controller] == 'news'

        if NewsArticle.find_by!(
            slug: result[:slug],
            # section: result[:section]
            section: Section.where('lower(name) = ?', result[:section]).first
        )
          #We found a NewsArticle, so it's a valid link
          return true
        end

      else
        raise "Unrecognised controller: #{result[:controller]}"
      end
    rescue ActiveRecord::RecordNotFound

    end
    #probably broken link
    false
  end

  def valid_uri?(url)
    !!URI.parse(url)
  rescue URI::InvalidURIError
    false
  end

  def private_route? href
    if href =~ /\A\/editorial\// ||
        href =~ /\A\/admin\// ||
        href =~ /\A\/users\//
      true
    else
      false
    end
  end

  def external_link?(href)
    uri = URI(href)

    if !uri.host
      return false
    end

    if ENV['APP_DOMAIN']
      uri.host.casecmp(ENV['APP_DOMAIN']) != 0
    else
      return false
    end


  end

end
