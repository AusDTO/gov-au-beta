module Synergy
  module PagesHelper

    def node_path(node)
      request.base_url + '/synergy' + node.path
    end

    def node_html(node)
      node.content.andand["body"]
    end
  end
end
