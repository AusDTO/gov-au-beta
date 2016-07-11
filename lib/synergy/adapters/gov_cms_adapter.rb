require 'net/http'
require 'uri'
require 'json'
require 'digest'
require 'fileutils'

module Synergy
  module Adapters
    class GovCMSAdapter
      attr_reader :section, :image_base_href

      def initialize(section)
        @section = section
        @url = "#{section.cms_url}/node.json?type=policy&status=1"
        @image_base_href = URI.parse(section.cms_url)
      end

      def run(&block)
        import_nodes(load_nodes, &block)
      end

      def log(message)
        Rails.logger.info "[#{destination_path}] #{message}"
      end

      def destination_path
        "/#{section.slug}"
      end

      private

      def import_nodes(nodes_hash)
        log "importing nodes"
        nodes_hash.values.sort(&method(:by_url_alpha)).each do |node|
          log "importing #{node["url"]}"
          node_data = to_node_data(node)
          if node_data[:content] && !node_data[:content].blank?
            yield(to_node_data(node))
          end
        end
        log "finished importing nodes"
      end

      def to_node_data(govcms_node)
        url = URI.parse(govcms_node["url"])

        {
          cms_ref: govcms_node["url"],
          cms_api_url: "#{@section.cms_url}/node/#{govcms_node["nid"]}.json",
          path: url.path,
          title: govcms_node["title"],
          content: extract_content(govcms_node)
        }
      end

      def extract_content(govcms_node)
        govcms_node["body"].andand["value"]
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
        page = response["next"] || response["last"]
        page.gsub(/\/node/, "/node.json")
      end

      def fetch(url)
        if Rails.env.development?
          dir = File.join(Rails.root, "tmp/cache/cms-import")
          FileUtils.mkdir_p dir
          path = "#{dir}/#{Digest::SHA256.hexdigest(url)}"
          if cached?(path)
            JSON.parse(cached(path))
          else
            JSON.parse(cache(path, fetch_uncached(url)))
          end
        else
          JSON.parse(fetch_uncached(url))
        end
      end

      def cached?(path)
        File.exists?(path)
      end

      def cached(path)
        File.read(path)
      end

      def cache(path, content)
        File.open(path, "w+"){|f| f.write(content)}
        content
      end

      def fetch_uncached(url)
        Net::HTTP.get_response(URI.parse(url)).body
      end

      def finished?(response)
        response["self"] == response["last"]
      end
    end
  end
end
