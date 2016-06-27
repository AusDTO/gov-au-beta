require 'net/http'

module Synergy
  module Adapters
    class CollaborationAdapter
      attr_reader :section

      def initialize(section)
        @section = section
      end

      def run(&block)
        import_nodes(&block)
      end

      def log(message)
        Rails.logger.info "[#{destination_path}] #{message}"
      end

      def destination_path
        "/#{section.slug}"
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
          source_url: node.path,
          path: node.path,
          title: node.name,
          content: node.content
        }
      end
    end
  end
end
