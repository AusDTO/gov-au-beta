require_dependency "synergy/application_controller"

module Synergy
  class PagesController < ApplicationController
    
    layout 'synergy/layouts/application'

    def show
      @root_node = Synergy::Node.find_by!(path: '/')

      path = params[:path].blank? ? '/' : "/#{params[:path]}"
      @node = Synergy::Node.find_by!(path: path)

      render action: :show
    end

  end
end
