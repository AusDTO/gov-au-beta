class DepartmentsController < ApplicationController
  layout 'application'

  decorates_assigned :departments

  def index
    @departments = Department.all.order(:name)
    bustable_fresh_when(@departments)
  end
end
