class DepartmentsController < ApplicationController
  layout 'application'

  decorates_assigned :departments

  def index
    @departments = Department.all.order(:name)
  end
end
