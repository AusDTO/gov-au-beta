include TemplatesHelper

class Api::TemplatesController < ApplicationController

  def index
    @templates = TemplatesHelper.list
  end
end