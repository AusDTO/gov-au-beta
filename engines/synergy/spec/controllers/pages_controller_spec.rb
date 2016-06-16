require 'rails_helper'

RSpec.describe Synergy::PagesController, :type => :controller do

  routes { Synergy::Engine.routes }

  # config.before(:each) { @routes = UserManager::Engine.routes }
  #
  # before do
  #   @routes = Synergy::Engine.routes
  # end

  describe 'GET #show' do
    let! (:node) { Synergy::Node.create!(slug: 'blah') }

    it "should return the page successfully" do
      get :show, path: 'blah'
      expect(response.status).to eq(200)
    end
  end
end
