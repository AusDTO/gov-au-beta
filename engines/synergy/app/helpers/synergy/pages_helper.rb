module Synergy
  module PagesHelper

    def node_path(node)
      '/synergy' + node.path
    end

    def node_html(node)
      if node.content
        if node.content['body']
          node.content['body']['value']
        elsif node.content['extra']
          node.content['extra']['value']
        end
      end
    end

  end
end
