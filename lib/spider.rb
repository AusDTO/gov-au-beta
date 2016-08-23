
require 'nokogiri'
require 'uri'
require 'fileutils'
require 'httparty'
require 'pathname'

# This code exists because I could not get wget to download the GOV.AU
# with a URL -> path/file mapping that would allow it to be served
# in such a way that the URLs are identical to production.
#
# For a path like /ministers/minister-for-women wget would create a file
# without and extension called /ministers/minister-for-women which a web
# server does not know how to serve.
#
# /ministers/minister-for-women/index.html is the correct file and folder
# path structure such that URL that is served statically to the user is
# /ministers/minister-for-women
#
# Every vanilla HTTP server worth its salt knows how to serve a default 
# page for a path.
#
# So that is what this code does: handles the spidering with *sane* file
# and folder output.
#
module Spider
  class Web

    # Asset tags are downloaded before crawling other links.
    ASSET_TAGS = %w(link script img)

    # Exhaustive list of HTML tags/attrs that contain URLs.
    # http://stackoverflow.com/questions/2725156/complete-list-of-html-tag-attributes-which-have-a-url-value
    LINK_ATTRS = {
      "a" => "href",
      "area" => "href",
      "base" => "href",
      "blockquote" => "cite",
      "body" => "background",
      "del" => "cite",
      "form" => "action",
      "frame" => "longdesc",
      "head" => "profile",
      "iframe" => "longdesc",
      "img" => "src",
      "ins" => "cite",
      "link" => "href",
      "q" => "cite",
      "script" => "src",
      "audio" => "src",
      "button" => "formaction",
      "command" => "icon",
      "embed" => "src",
      "html" => "manifest",
      "source" => "src",
      # NOTE: some elements have multiple URL attrs - deal with this later.
      #"video" => ["poster", "src"]
      #"input" => ["formaction","src"]
      #"img" => ["src", "longdesc"],
    }.freeze

    def initialize(root_url, options={})
      @root_uri = URI(root_url)
      @basic_auth = options[:basic_auth]
      out_dir = Pathname.new(options[:out_dir] || "out")
      if out_dir.absolute?
        @out_dir = out_dir
      else
        @out_dir = Pathname.new("#{Dir.pwd}/#{out_dir}")
      end
      @max_depth = options[:max_depth] || 20
      @visited = Set.new
    end

    def run
      FileUtils.mkdir_p(@out_dir)
      crawl(@root_uri, 0)
    end

    private

    def crawl(url, depth)
      return if url.nil?
      begin
        uri = URI(url)
      rescue
        STDERR.puts "could not parse URL '#{url}' (#{$!.message})"
        return
      end
      if !@visited.include?(uri) && !external?(uri) && has_crawlable_scheme?(uri)
        STDERR.puts("crawling (#{uri})")
        @visited.add(uri)
        raise "url must be absolute!" unless uri.absolute?
        response = get(uri)
        local_path = map_uri_to_local_path(uri, uri)
        if response.ok?
          case response.headers["Content-Type"]
          when /html/
            process_html(local_path, uri, response, depth)
          else
            write_binary_file(local_path, response)
          end
        else
          STDERR.puts "failed to GET (#{url})"
        end
      end
    end

    def process_html(local_path, uri, response, depth)
      nodes = Nokogiri::HTML(response.body)
      rewritten_content = rewrite_links_in_content(nodes, uri)
      write_file(local_path + "/index.html", rewritten_content.to_html)
    
      asset_links(nodes).each do |link|
        crawl(URI.join(uri, link), depth) # rescue nil
      end

      unless depth >= @max_depth
        non_asset_links(nodes).each do |link|
          crawl(URI.join(uri, link), depth + 1) # rescue nil
        end
      end
    end

    def external?(uri)
      uri.host && uri.host.casecmp(@root_uri.host) == 0
    end

    def has_crawlable_scheme?(uri)
      scheme = uri.scheme
      scheme.nil? || scheme == "http" || scheme == "https"
    end

    def get(uri)
      if @basic_auth
        HTTParty.get(uri, :basic_auth => @basic_auth)
      else
        HTTParty.get(uri)
      end
    end

    def asset_links(nodes)
      links(nodes) {|l| !ASSET_TAGS.include?(l[:tag]) }
    end

    def non_asset_links(nodes)
      links(nodes) {|l| ASSET_TAGS.include?(l[:tag]) }
    end

    def links(nodes, &filter)
      LINK_ATTRS.each_pair
        .map(&extract_attr(nodes))
        .reject(&filter)
        .map{|l| l[:links]}
        .flatten
    end

    def extract_attr(nodes)
      ->((tag, attr)) {
        links = nodes.search(tag)
          .map{|el| el[attr]}
          .reject{|link| link.nil?}
          .reject{|link| link =~ /^javascript/}
        {
          tag: tag,
          links:links 
        }
      }
    end

    def rewrite_links_in_content(html, current_page_uri)
      LINK_ATTRS.each_pair do |tag, attr|
        html.search(tag).each do |el|
          attr_value = el[attr]
          if attr_value
            link_uri = URI(attr_value) rescue nil
            if link_uri
              el[attr] = convert_link(link_uri, current_page_uri)
            end
          end
        end
      end
      html
    end

    def convert_link(link_uri, current_page_uri)
      if link_uri.host == @root_uri.host
        map_uri_to_local_path(link_uri, current_page_uri)
      else
        link_uri.to_s
      end
    end

    def map_uri_to_local_path(link_uri, current_page_uri)
      URI.join(current_page_uri, link_uri).path
    end

    # Writes file content to *path* where path is relative to *@out_dir*.
    def write_file(path, content)
      path = path.gsub(%r(^//), "/")
      destination = Pathname(@out_dir + path[1..-1])
      STDERR.puts("writing: #{destination}")
      FileUtils.mkdir_p(destination.dirname)
      File.open(destination, "w+") {|f| f.write(content) }
    end

    # Writes file content to *path* where path is relative to *@out_dir*.
    def write_binary_file(path, content)
      path = path.gsub(%r(^//), "/")
      destination = Pathname(@out_dir + path[1..-1])
      STDERR.puts("writing binary: #{destination}")
      FileUtils.mkdir_p(destination.dirname)
      File.open(destination, "wb") do |f|
        f.binmode
        f.write(content)
        f.close
      end
    end
  end
end
