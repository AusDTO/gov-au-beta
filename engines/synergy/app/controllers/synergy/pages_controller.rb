require_dependency "synergy/application_controller"

module Synergy
  class PagesController < ApplicationController

    def show
      node = parent = Synergy::Node.find_by!(slug: '/')

      if params[:path]
        path = params[:path].split('/')
        path.each do |p|
          parent = node = parent.children.find_by!(slug: p)
        end
      end

      render :json => node
    end

  end
end
