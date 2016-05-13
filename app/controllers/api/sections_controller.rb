class Api::SectionsController < ApplicationController
  def index
    @sections = Section.all
  end
end