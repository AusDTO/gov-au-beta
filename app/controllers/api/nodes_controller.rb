class Api::NodesController < ApplicationController
  # allow external post for create to allow JSON API creation of pages
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    if params['updated_node'] and params['updated_revision']
      NodeCreateJob.perform_later params['updated_node'],params['updated_revision']
      head :created
    else
      head :bad_request
    end
  end
end