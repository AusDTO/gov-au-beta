require 'rails_helper'
include ContentAnalysisHelper

RSpec.describe ContentAnalysisHelper do

  context 'invalid http status' do
    it 'should raise an error' do
      stub_request(:post, Rails.application.config.content_analysis_base_url + '/api/linters')
          .to_return(status: 500)
      expect { ContentAnalysisHelper.lint('body') }.to raise_error(/500/)
    end
  end
end