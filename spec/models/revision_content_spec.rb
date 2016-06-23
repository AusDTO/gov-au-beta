require 'rails_helper'

RSpec.describe RevisionContent, type: :model do
  let(:variant_one) { 'The quick brown fox jumps over the lazy dog' }
  let(:variant_two) { 'The fox is dead' }
  let(:node) { Fabricate(:general_content, content_body: nil) }
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
end
