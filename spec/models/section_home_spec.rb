require 'rails_helper'

RSpec.describe SectionHome, type: :model do

  it { is_expected.to validate_presence_of :section }

  let(:root_node) { Fabricate(:root_node) }
  let(:first_child) { Fabricate(:node, parent: root_node) }
  let(:too_deep) { Fabricate.build(:section_home, parent: first_child)}

  it 'should validate that it has no grandparent' do
    expect(too_deep).not_to be_valid
  end

end
