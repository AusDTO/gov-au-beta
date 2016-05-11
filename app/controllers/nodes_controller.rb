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
      layout = @section.layout.presence

      if layout 
        render "templates/#{@node.template}", layout: layout
      else
        render "templates/#{@node.template}"
      end
    else
      raise ActiveRecord::RecordNotFound.new "Invalid path: #{params[:path]}"
    end
  end

end