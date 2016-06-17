module Synergy
  module PagesHelper

    def node_path(node)
      '/synergy' + node.path
    end

    def node_html(node)
      if node.content
        if node.content['body']
          node.content['body']['value']
        end
      end
    end

    def tree_view(label_method = :to_s,  node = nil, level = -1)
     if node.nil?
       puts "root"
       nodes = roots
     else
       label = "|_ #{node.send(label_method)}"
       if level == 0
         puts " #{label}"
       else
         puts " |#{"    "*level}#{label}"
       end
       nodes = node.children
     end
     nodes.each do |child|
       tree_view(label_method, child, level+1)
     end
   end

  end
end
