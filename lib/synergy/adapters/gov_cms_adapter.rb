require 'net/http'
require 'uri'
require 'json'

module Synergy
  module Adapters
    class GovCMSAdapter
      def initialize(source_name, url)
        @source_name = source_name
        @url = "#{url}/node.json?field_current_revision_state=published"
        @image_base_href = URI.parse(url)
      end

      def run(&block)
        import_nodes(load_nodes, &block)
      end

      def log(message)
        Rails.logger.info "[#{@source_name}] #{message}"
      end

      private

      def import_nodes(nodes_hash)
        log "importing nodes"
        nodes_hash.values.sort(&method(:by_url_alpha)).each do |node|
          log "importing #{node["url"]}"
          yield(to_node_data(node))
        end
        log "finished importing nodes"
      end

      def to_node_data(govcms_node)
        url = URI.parse(govcms_node["url"])

        {
          source_url: govcms_node["url"],
          path: url.path.split("/").select{|p| !p.blank?},
          title: govcms_node["field_title"],
          content: extract_content(govcms_node)
        }
      end

      def extract_content(govcms_node)
        # NOTE: GovCMS can return a hash, or an array (always empty for some reason) or nil
        # for field content. Only the hash version is useful.
        {
          body: absolutify_image_links(
                  (govcms_node["field_content_main"].andand["value"] rescue nil) ||
                  (govcms_node["field_content_extra"].andand["value"] rescue nil)
                )
        }
      end

      def absolutify_image_links(content)
        html = Nokogiri::HTML(content)
        html.search("img").each do |node|
          src = node["src"]
          unless src.empty?
            uri = URI.parse(URI.escape(src))
            unless uri.host
              uri.scheme = @image_base_href.scheme
              uri.host = @image_base_href.host
              node["src"] = uri.to_s
            end
          end
        end
        html.to_html
      rescue
        Rails.logger.error "[#{@source_name}] Could not parse HTML content: #{$!.message}"
        content
      end

      def load_nodes
        log "loading nodes"
        response = fetch(@url)
        nodes = {}

        log "starting fetch..."

        while !finished?(response) do
          fetched = response["list"]
          nodes.merge!(nodes_by_url(fetched))
          response = fetch(next_page(response))
          log "fetched #{nodes.count} nodes"
        end
        log "finished loading nodes"
        nodes
      end

      def by_url_alpha(a,b)
        a["url"] <=> b["url"]
      end

      def nodes_by_url(nodes)
        nodes.reduce({}) do |by_url, node|
          by_url[node["url"]] = node
          by_url 
        end
      end

      def next_page(response)
        response["next"].gsub(/\/node/, "/node.json")
      end

      def fetch(url)
        JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)
      end

      def finished?(response)
        response["self"] == response["last"]
      end
    end
  end
end
