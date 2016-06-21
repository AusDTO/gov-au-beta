require 'rails_helper'

RSpec.describe Synergy::PageController, :type => :controller do
  describe 'GET #show' do

    it "should return the page successfully" do
      # get :show, params: {:section => "root", path: "one"}
      expect(100).to eq(200)
    end

  end
end
