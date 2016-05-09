class NodesController < ApplicationController

  def show
    @section = Section.find_by(slug: params[:section])
    @node = nil
    if params[:path] and @section
      params[:path].split('/').each_with_index do |node, idx|
        if @node == nil && idx == 0
          @node = @section.nodes.find_by(slug: node)
        else
          s_node = @node.children.find_by(slug: node)
          if s_node
            @node = s_node
          else
            @node = nil
            break
          end
        end
      end
    end
    if @node
      render "templates/#{@node.template}"
    else
      render file: "#{Rails.root}/public/404.html", status: 404
    end
  end

end