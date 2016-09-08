require 'rails_helper'

RSpec.describe Admin::AgenciesController, type: :controller do

  include ActiveJob::TestHelper

  let(:agency) { Fabricate :agency }
  let(:admin) { Fabricate(:user, is_admin: true) }

  describe '#find_resource' do

    subject { Admin::AgenciesController.new.find_resource agency.id }

    it { is_expected.to eq agency }

  end

end
