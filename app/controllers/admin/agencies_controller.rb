module Admin
  class AgenciesController < Admin::ApplicationController
    def find_resource(param)
      Agency.find_by! slug: param
    end

    def import
      agency = requested_resource
      ImportCmsNodesJob.perform_later(agency.id)
      flash.keep[:notice] = "Import scheduled for #{agency.slug}."
      redirect_to :action => :index
    end
  end
end
