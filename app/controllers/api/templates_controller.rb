class Api::TemplatesController < ApplicationController

  def index
    templates = TemplatesHelper.list
    render :json => templates
  end
end