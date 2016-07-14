module Admin
  class AgenciesController < Admin::ApplicationController
    def find_resource(param)
      Agency.find param
    end

    def import
      agency = requested_resource
      ImportCmsNodesJob.perform_later(agency.id)
      flash.keep[:notice] = "Import scheduled for #{agency.name}."
      redirect_to :action => :index
    end
  end
end
