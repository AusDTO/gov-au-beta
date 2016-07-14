require 'rails_helper'

RSpec.describe RevisionContent, type: :model do
  let!(:root_node) { Fabricate(:root_node) }
  let(:variant_one) { 'The quick brown fox jumps over the lazy dog' }
  let(:variant_two) { 'The fox is dead' }
  let(:node) { Fabricate(:general_content, parent: root_node, content_body: nil) }
  let(:revision_one) { node.revise!(content_body: variant_one) }
  let(:revision_two) { node.revise!(content_body: variant_two)}

  describe 'on an empty node' do
    subject { RevisionContent.new(revision_one).content_body }
    it { is_expected.to eq variant_one }
  end

  describe 'on a published node' do
    before do
      revision_one.apply!
      node.reload
    end

    subject { RevisionContent.new(revision_two).content_body }

    it { is_expected.to eq variant_two }
  end

  describe '#all_content' do
    let(:clean_node) { Fabricate(:general_content, parent: root_node) }
    let(:missing_name) { clean_node.revise!(content_body: variant_one) }

    # remove all 'name' diffs to simulate a revision set that doesn't set the name
    before do
      missing_name.self_and_ancestors.each do |rev|
        d = rev.diffs
        d.delete(:name)
        rev.diffs = d
        rev.save!
      end
    end
    it 'includes attributes with diffs' do
      expect(RevisionContent.new(revision_one).all_content.keys).to include(:name)
    end
    it 'does not include attributes without diffs' do
      expect(RevisionContent.new(missing_name).all_content.keys).not_to include(:name)
    end
  end
end
