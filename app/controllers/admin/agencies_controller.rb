module Admin
  class AgenciesController < Admin::ApplicationController
    def find_resource(param)
      Agency.find param
    end
  end
end
