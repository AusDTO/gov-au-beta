require 'rails_helper'
RSpec.describe Api::TemplatesController do

  describe 'GET #index' do
    render_views

    context 'given a request to index' do
      it 'returns a json list of templates' do
        @expected = YAML.load_file("#{Rails.root}/app/views/templates/conf.yaml").to_json
        expect(get :index, :format => :json).to be_success
        expect(response.body).to eq @expected
      end
    end
  end
end