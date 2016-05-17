class Api::LintersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:parse]


  def parse
    if content = params['content']
      @results = ContentLinter.new(content).parse
    else
      head :bad_request
    end
  end
end