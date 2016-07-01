require 'rails_helper'

RSpec.describe Section, type: :model do

  context 'a section can be related to other sections ' do
    let(:section) { Fabricate(:section) }
    let(:connected) { Fabricate(:section) }

    before do
      section.sections << connected
    end

    it 'has a connection' do
      expect(section.sections).to eq [connected]
    end

  end

  context 'a department can be related to agencies' do
    let(:dept) { Fabricate(:department) }
    let(:connected) { Fabricate(:section) }
    let(:agency) { Fabricate(:agency) }

    before do
      dept.sections << connected
      dept.agencies << agency
    end

    it 'has a connection' do
      expect(dept.sections).to eq [connected, agency]
      expect(dept.agencies).to eq [agency]
    end

  end


end
