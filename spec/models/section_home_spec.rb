require 'rails_helper'

RSpec.describe SectionHome, type: :model do

  it { is_expected.to validate_presence_of :section }

  describe 'depth validation' do
    let(:first_child_of_root) { Fabricate(:section_home) }

    subject { Fabricate.build(:section_home, parent: first_child_of_root)}

    it { is_expected.not_to be_valid }
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
