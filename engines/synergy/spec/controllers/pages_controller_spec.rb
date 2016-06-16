require 'rails_helper'

RSpec.describe Synergy::PagesController, :type => :controller do

  routes { Synergy::Engine.routes }

  # config.before(:each) { @routes = UserManager::Engine.routes }
  #
  # before do
  #   @routes = Synergy::Engine.routes
  # end


  describe 'GET #show' do
    before do
      root = Synergy::Node.create!(slug: '/')
      parent = root.children.create!(slug: 'blah')
      parent.children.create!(slug: 'vtha')
    end
    # let! (:node) { Synergy::Node.create!(slug: 'blah') }

    it "should return a page" do
      get :show, path: 'blah/vtha'
      expect(response.status).to eq(200)
    end

    it "should return an error on 404 " do
      expect {
        get :show, path: 'vtha/blah'
      }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
