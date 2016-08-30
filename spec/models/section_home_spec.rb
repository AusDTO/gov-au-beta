require 'rails_helper'

RSpec.describe SectionHome, type: :model do

  it { is_expected.to validate_presence_of :section }

  describe 'depth validation' do
    let(:first_child_of_root) { Fabricate(:section_home) }

    subject { Fabricate.build(:section_home, parent: first_child_of_root)}

    it { is_expected.not_to be_valid }
  end

  describe 'changing the parent' do
    let(:section_home_1) { Fabricate(:section_home) }
    let(:section_home_2) { Fabricate(:section_home) }

    it 'fails for an existing record' do
      expect(section_home_1.errors_on(:parent_id)).to eql([])
      section_home_1.parent = section_home_2
      expect(section_home_1.errors_on(:parent_id)).to eql(["Change of parent not permitted for section home"])
    end
  end

  describe 'uniqueness' do
    let(:section)                { Fabricate(:section) }
    let!(:existing_section_home) { Fabricate(:section_home, section: section) }

    subject do
      Fabricate.build(:section_home, section: section)
    end

    it { is_expected.not_to be_valid }
  end

  describe 'name' do
    let!(:section)      { Fabricate(:section, name: "FOO") }
    let!(:section_home) { Fabricate(:section_home, section: section, name: "FOO") }

    it 'updates section name when name is changed' do
      expect(section.name).to eql("FOO")
      section_home.name = "BAR"
      section_home.save!
      section.reload
      expect(section.name).to eql("BAR")
    end
  end
end
