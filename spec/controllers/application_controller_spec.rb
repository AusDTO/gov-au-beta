
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  controller do
    def initialize(*args)
      super
      @some_data = Fabricate(:node)
    end

    def show 
      if bustable_stale?(@some_data)
        render :text => "Oh hi there!"
      end
    end
  end

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
      controller.stub(:etag_seed).and_return "CURRENT_SHA1"

      get :show, :id => "ignored"
      assert_response 200, @response.body
      etag = @response.headers["ETag"]
      @request.env["HTTP_IF_NONE_MATCH"] = etag
      get :show, :id => "ignored"
      assert_response 304, @response.body

      # Deploy!
      controller.stub(:etag_seed).and_return "NEW_SHA1"

      @request.env["HTTP_IF_NONE_MATCH"] = etag
      get :show, :id => "ignored"
      assert_response 200, @response.body
    end
  end
end
