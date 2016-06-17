require_dependency "synergy/application_controller"

module Synergy
  class PagesController < ApplicationController
    attr_accessor :node
    helper_method :node

    layout 'synergy/layouts/application'

    def show
      path = params[:path].blank? ? '' : "/#{params[:path]}"
      @node = Synergy::Node.find_by!(path: path)
      render action: :show
    end

  end
end
