require_dependency "synergy/application_controller"

module Synergy
  class PagesController < ApplicationController
    attr_accessor :node
    helper_method :node

    def index
      @node = Synergy::Node.find_by!(slug: '')
      # @tree = Synergy::Node.tree_view(:slug)
      render action: :index
    end

    def show
      node = parent = Synergy::Node.find_by!(slug: '')

      if params[:path]
        path = params[:path].split('/')
        path.each do |p|
          parent = node = parent.children.find_by!(slug: p)
        end
      end
      @node = node
      render action: :show
    end

  end
end
