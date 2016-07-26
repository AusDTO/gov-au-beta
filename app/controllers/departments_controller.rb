class DepartmentsController < ApplicationController
  layout 'application'
  attr_accessor :departments
  helper_method :departments

  def index
    @departments = Department.all.order(:name)
  end

end
