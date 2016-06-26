require 'net/http'

module Synergy
  module Adapters
    class CollaborationAdapter
      attr_accessor :source_name, :url, :destination_path

      def initialize(source_name, url, destination_path)
        @source_name = source_name
        @url = url
        @destination_path = destination_path
      end

      def run(&block)
        import_nodes(&block)
      end

      def log(message)
        Rails.logger.info "[#{source_name}] #{message}"
      end

      private

      def import_nodes(&block)
        log "importing nodes"
        Node.where(parent_id: nil, state: :published).each do |node|
          import_node(node, &block)
        end
        log "finished importing nodes"
      end

      def import_node(node, &block)
        log "importing #{node.path}"
        yield(to_node_data(node))
        node.children.where(state: :published).each do |child|
          import_node(child, &block)
        end
      end

      def to_node_data(node)
        {
          source_url: url,
          path: node.path,
          title: node.name,
          content: node.content
        }
      end
    end
  end
end
