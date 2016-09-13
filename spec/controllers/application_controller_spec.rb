require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  controller do
    def initialize(*args)
      super
      @some_data = Fabricate(:general_content)
    end

    def show
      with_caching(@some_data) do
        render :text => "Oh hi there!"
      end
    end
  end

  shared_examples_for "does not generate an ETAG" do
    it "does not generate an ETAG" do
      get :show, :id => "ignored"
      assert_response 200, @response.body
      expect(@response.headers["ETag"]).to be_falsey
    end
  end

  context "not logged in" do
    it "generates and respects ETAGs" do
      get :show, :id => "ignored"
      assert_response 200, @response.body
      etag = @response.headers["ETag"]
      @request.env["HTTP_IF_NONE_MATCH"] = etag
      get :show, :id => "ignored"
      assert_response 304, @response.body
    end

    describe "when a new version of the application is deployed" do

      it "busts the ETAG" do
        allow(controller).to receive(:etag_seed).and_return("CURRENT_SHA1")

        get :show, :id => "ignored"
        assert_response 200, @response.body
        etag = @response.headers["ETag"]
        @request.env["HTTP_IF_NONE_MATCH"] = etag
        get :show, :id => "ignored"
        assert_response 304, @response.body

        # Deploy!
        allow(controller).to receive(:etag_seed).and_return "NEW_SHA1"

        @request.env["HTTP_IF_NONE_MATCH"] = etag
        get :show, :id => "ignored"
        assert_response 200, @response.body
      end
    end

    context "when a flash message is shown" do
      before(:each) do
        allow(controller).to receive(:flash).and_return({"message" => "I am not empty"})
      end

      include_examples "does not generate an ETAG"
    end
  end

  context "logged in" do
    let(:user) { Fabricate(:user) }
    before(:each) do
      sign_in(user)
    end

    include_examples "does not generate an ETAG"
  end

end
