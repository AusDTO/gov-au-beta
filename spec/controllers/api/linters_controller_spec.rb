require 'rails_helper'

RSpec.describe Api::LintersController do
  render_views
  describe "POST #parse" do
    context "given a sentence with bad words in it" do
      it "returns a list of bad words and their suggested good words" do
        expect(
          post :parse, :params => {:content => "Federal Government"}
        ).to be_success

        expect(JSON.load(response.body).size).to eq(1)
      end

    end

    context "given a sentence with no bad words in it" do
      it "returns an empty json list" do
        expect(
            post :parse, :params => {:content => "No bad words here"}
        ).to be_success

        expect(JSON.load(response.body).size).to eq(0)
      end
    end

    context "given no parameters are supplied" do
      it "returns an unsuccessful header" do
        expect(
            post :parse
        ).to_not be_success
      end
    end
  end
end