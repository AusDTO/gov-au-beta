require_dependency "synergy/application_controller"

module Synergy
  class EventsController < ApplicationController

    def index
      render json: 'Events'
    end

    def create
    end
  end
end
