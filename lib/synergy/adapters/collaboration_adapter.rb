require 'net/http'

module Synergy
  module Adapters
    class CollaborationAdapter
      attr_accessor :source_name, :url

      def initialize(source_name, url)
        @source_name = source_name
        @url = url
      end

      def run(&block)
        import_nodes(&block)
      end

      def log(message)
        Rails.logger.info "[#{source_name}] #{message}"
      end

      private

      def import_nodes
        log "importing nodes"

        nodes = []
        ::Node.where(parent_id: nil).each do |node|
          nodes << import_node(node)
        end
        nodes.flatten.each do |node|
          yield(to_node_data(node))
        end

        log "finished importing nodes"
      end

      def import_node(node)
        log "importing #{node.path}"
        node.children.reduce([node]) do |nodes, child|
          nodes << import_node(child)
        end
      end

      def to_node_data(node)
        {
          source_url: url,
          path: node.path_elements,
          title: node.name,
          content: node.content
        }
      end
    end
  end
end
