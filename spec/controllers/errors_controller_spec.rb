require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do

  before do
    Rails.application.config.consider_all_requests_local = false
    load "application_controller.rb"
  end

  after do
    Rails.application.config.consider_all_requests_local = true
    load "application_controller.rb"
  end

  describe "GET #not_found" do
    it "returns http 404 not found" do
      get :not_found
      expect(response).to have_http_status(404)
    end
  end

  describe "GET #change_rejected" do
    it "returns http 422 change rejected" do
      get :change_rejected
      expect(response).to have_http_status(422)
    end
  end

  describe "GET #internal_server_error" do
    it "returns http 500 internal server error" do
      get :internal_server_error
      expect(response).to have_http_status(500)
    end
  end

end
