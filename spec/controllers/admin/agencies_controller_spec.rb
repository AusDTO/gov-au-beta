require 'rails_helper'

RSpec.describe Admin::AgenciesController, type: :controller do

  describe '#find_resource' do

    let(:agency) { Fabricate :agency }

    subject { Admin::AgenciesController.new.find_resource agency.slug }

    it { should eq agency }

  end

end