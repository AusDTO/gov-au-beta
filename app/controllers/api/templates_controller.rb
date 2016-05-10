class Api::TemplatesController < ApplicationController
  def index
    templates = YAML.load_file("#{Rails.root}/app/views/templates/conf.yaml")
    render :json => templates
  end
end