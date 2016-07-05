require 'rails_helper'

RSpec.describe Admin::AgenciesController, type: :controller do

  include ActiveJob::TestHelper

  let(:agency) { Fabricate :agency }
  let(:admin) { Fabricate(:user, is_admin: true) }

  describe '#find_resource' do

    subject { Admin::AgenciesController.new.find_resource agency.id }

    it { is_expected.to eq agency }

  end

  describe '#import' do
    before { sign_in(admin) }

    it "schedules an import" do
      assert_enqueued_jobs 0
      post :import, id: agency.id
      assert_enqueued_jobs 1
    end

    it "sets a flash message" do
      post :import, id: agency.id
      expect(flash[:notice]).to eql("Import scheduled for #{agency.name}.")
    end
  end

end
