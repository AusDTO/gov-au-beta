require 'rails_helper'

RSpec.describe GeneralContent, type: :model do

  describe 'recursive ancestry' do
    let!(:root) { Fabricate(:root_node) }
    let(:section) { Fabricate(:section) }
    subject(:parent) { Fabricate(:general_content, section: section,
      parent: section.home_node) }
    let(:child) { Fabricate(:general_content, section: section,
      parent: parent) }

    before do
      parent.parent = child
    end

    it { is_expected.not_to be_valid }

    # n.b. NonRecursiveAncestryValidator runs first, which stops
    # AncestryDepthValidator from getting into a recursive tizzy.
    it 'should not throw an exception when validating' do
      expect { subject.valid? }.not_to raise_error
    end
  end
end
