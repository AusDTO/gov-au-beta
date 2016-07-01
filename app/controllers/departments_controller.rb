class DepartmentsController < ApplicationController
  layout 'section'
  attr_accessor :departments
  helper_method :departments

  def index
    @departments = Department.all.order(:name)
    render layout: 'application'
  end

end
