require 'rails_helper'

RSpec.describe Section, type: :model do

  describe 'a section can be related to other sections ' do
    let(:section) { Fabricate(:section) }
    let(:connected) { Fabricate(:section) }

    before do
      section.sections << connected
    end

    it 'has a connection' do
      expect(section.sections).to eq [connected]
    end

  end

  describe 'a department can be related to agencies and topics' do
    let(:dept) { Fabricate(:department) }
    let(:connected) { Fabricate(:section) }
    let(:agency) { Fabricate(:agency) }
    let(:topic) { Fabricate(:topic) }

    before do
      dept.sections << connected
      dept.sections << agency
      dept.sections << topic
    end

    it 'has a connection' do
      expect(dept.sections).to eq [connected, agency, topic]
      expect(dept.agencies).to eq [agency]
      # expect(agency.departments).to eq [dept]
      expect(dept.topics).to eq [topic]
    end
  end


end
