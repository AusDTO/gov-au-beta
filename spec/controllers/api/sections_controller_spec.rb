require 'rails_helper'

RSpec.describe Api::SectionsController do
  render_views
  describe 'GET #index' do
    let!(:root) { Fabricate(:section, name: 'root')}
    let!(:business) { Fabricate(:section, name: 'business')}
    context 'given a request to index' do
      it 'should return a json list of sections' do


        expected = Section.all.as_json.inject([]) do |agg, item|
          agg << {
              'id' => item['id'],
              'name' => item['name'],
              'slug' => item['slug']
          }
          agg
        end

        expect(get :index, :format => :json).to be_success
        response.body.should == expected.to_json

      end
    end
  end
end