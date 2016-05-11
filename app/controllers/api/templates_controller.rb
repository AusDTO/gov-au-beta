include TemplateHelper

class Api::TemplatesController < ApplicationController

  def index
    templates = TemplateHelper.list
    render :json => templates
  end
end