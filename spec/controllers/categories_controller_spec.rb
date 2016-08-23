require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  describe 'GET #infrastructure_and_telecommunications' do
    let(:infrastructure_and_telecommunications) { Fabricate(:category, name: 'Infrastructure and telecommunications')}

    it "returns http success" do
      get :show, params: {slug: infrastructure_and_telecommunications.slug}
      expect(response).to have_http_status(:success)
    end
  end

end
