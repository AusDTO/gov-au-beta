class DepartmentsController < ApplicationController
  layout 'application'

  decorates_assigned :departments

  def index
    @departments = Department.all.order(:name)
    with_caching(@departments)
  end
end
