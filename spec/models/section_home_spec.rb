require 'rails_helper'

RSpec.describe SectionHome, type: :model do
  let!(:root_node) { Fabricate(:root_node) }

  it { is_expected.to validate_presence_of :section }

  describe 'depth validation' do
    let(:first_child) { Fabricate(:node, parent: root_node) }
    subject { Fabricate.build(:section_home, parent: first_child)}

    it { is_expected.not_to be_valid }
  end

  describe 'uniqueness' do
    let(:section) { Fabricate(:section) } # SectionHome is automatically generated
    subject { Fabricate.build(:section_home, parent: root_node,
      section: section) }
    it { is_expected.not_to be_valid }
  end

end
