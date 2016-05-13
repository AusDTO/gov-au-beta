require 'rails_helper'
RSpec.describe Api::NodesController do

  describe "POST #create" do
    context "given a content id" do
      it "creates node create jobs" do
        ActiveJob::Base.queue_adapter = :test

        expect {
          post :create, :params => {:updated_node => "1", :updated_revision => "1"}
        }.to have_enqueued_job.with("1", "1")

        expect(response).to be_success
        expect(response).to have_http_status(:created)

      end
    end
    context "missing a content id" do
      it "returns an error" do
        ActiveJob::Base.queue_adapter = :test

        expect {
          post :create
        }.to_not have_enqueued_job.with("1", "1")

        expect(response).to_not be_success
        expect(response).to have_http_status(:bad_request)

      end
    end
  end
end
