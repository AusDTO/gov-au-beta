require_dependency "synergy/application_controller"

module Synergy
  class PagesController < ApplicationController

    def show
      # Synergy::Node.create(slug: 'blah/vtha')
      # Synergy::Node.create(slug: 'blah')
      
      node = Synergy::Node.find_by!(slug: params[:path])
      render :json => node
    end

  end
end
