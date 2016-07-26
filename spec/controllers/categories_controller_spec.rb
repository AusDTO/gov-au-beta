require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  describe 'GET #infrastructure_and_telecommunications' do
    it "returns http success" do
      get :infrastructure_and_telecommunications
      expect(response).to have_http_status(:success)
    end
  end

end
