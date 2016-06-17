
require 'net/http'
require 'uri'
require 'json'
require 'pry'

module Synergy
  class GovCMSImport

    STARTING_URL = "https://edit.dev.aus.gov.au/node.json?field_current_revision_state=published"

    def self.run
      puts "Deleting all nodes"
      Synergy::Node.delete_all
      insert_nodes(load_nodes)
    end

    def self.insert_nodes(nodes_hash)
      nodes_hash.values.sort(&method(:by_url_alpha)).each do |node|
        puts "Importing #{node["url"]}"

        url = URI.parse(node["url"])
        parts = url.path[1..-1].split("/")

        leaf_s_node = parts.reduce(nil) do |parent_s_node,slug|
          Synergy::Node.find_or_create_by! parent: parent_s_node, slug: slug
        end

        content = {}
        if node["field_content_main"]
          content[:body] = node["field_content_main"]
        end
        if node["field_content_extra"]
          content[:extra] = node["field_content_extra"]
        end
        leaf_s_node.content = content
        leaf_s_node.save!
      end
      puts "Done importing nodes"
    end

    def self.load_nodes
      response = fetch(STARTING_URL)
      nodes = {}

      puts "Starting fetch..."

      while !finished?(response) do
        fetched = response["list"]
        nodes.merge!(nodes_by_url(fetched))
        response = fetch(next_page(response))
        puts "Fetched #{nodes.count} nodes"
      end
      nodes
    end

    def self.by_url_alpha(a,b)
      a["url"] <=> b["url"]
    end

    def self.nodes_by_url(nodes)
      nodes.reduce({}) do |by_url, node|
        by_url[node["url"]] = node
        by_url 
      end
    end

    def self.next_page(response)
      response["next"].gsub(/\/node/, "/node.json")
    end

    def self.fetch(url)
      JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)
    end

    def self.finished?(response)
      response["self"] == response["last"]
    end
  end
end
