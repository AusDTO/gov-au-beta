require 'rails_helper'

RSpec.describe Synergy::PagesController, :type => :controller do

  routes { Synergy::Engine.routes }

  describe 'GET #show' do
    let(:root)    { Synergy::Node.create!(slug: '') }
    let(:parent)  { root.children.create!(slug: 'blah') }
    let!(:node)    { parent.children.create!(slug: 'vtha') }

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
