require 'rails_helper'

describe SectionDashboard do
  describe '#display_resource' do
    let(:agency) { Fabricate :agency }

    it 'should show the section name' do
      expect(subject.display_resource(agency)).to eq agency.name
    end
  end
end
