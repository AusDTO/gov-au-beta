require 'rails_helper'

RSpec.describe Revision, type: :model do
  let(:root_node) { Fabricate(:root_node) }

  describe 'scopes' do
    let(:node) { Fabricate(:node, parent: root_node, content_body: nil, name: nil) }
    let!(:first_applied_revision) { Fabricate(:revision, revisable: node, applied_at: 4.days.ago) }
    let!(:second_applied_revision) { Fabricate(:revision, revisable: node, applied_at: 4.days.ago) }
    let!(:first_pending_revision) { Fabricate(:revision, revisable: node, created_at: 2.days.ago) }
    let!(:second_pending_revision) { Fabricate(:revision, revisable: node, created_at: 1.day.ago) }

    it 'should flag instances' do
      expect(first_pending_revision).to be_pending
      expect(first_applied_revision).to be_applied
    end

    it 'should flag instances' do
      expect(first_pending_revision).to be_pending
      expect(first_applied_revision).to be_applied
    end

    describe 'applied' do
      subject { node.revisions.applied }

      it { is_expected.to eq [first_applied_revision, second_applied_revision] }
      it { is_expected.not_to include first_pending_revision }
    end

    describe 'pending' do
      subject { node.revisions.pending }

      it { is_expected.to eq [first_pending_revision, second_pending_revision] }
      it { is_expected.not_to include first_applied_revision }
    end

    describe 'one version ahead' do
      subject { node.revisions.pending.until first_pending_revision }

      it { is_expected.to eq [first_pending_revision] }
    end

    describe 'one version behind' do
      subject { node.revisions.applied.since first_applied_revision }

      it { is_expected.to eq [second_applied_revision] }
    end
  end

  describe '#ancestors' do

  end

  describe '#apply!' do
    let(:node) { Fabricate(:node, parent: root_node, content_body: 'initial content') }
    let(:revision) { node.revise! content_body: 'changed content' }

    context 'before applying revision' do
      it 'should not affect node content' do
        expect(node.content_body).to eq 'initial content'
      end
    end

    context 'after applying revision' do
      before do
        node.reload
        revision.apply!
      end

      it 'should affect node content' do
        node.reload
        expect(node.content_body).to eq 'changed content'
      end

      it 'should be marked as applied' do
        expect(revision).to be_applied
      end
    end
  end

  describe 'patching' do
    let(:node) { Fabricate(:node, parent: root_node, content_body: nil) }
    let(:basic_content) { "a\n\nb\n\nc" }
    let(:revised_content) { "a#{"\n" * 20}b\nc" }

    before do
      node.revise!(content_body: basic_content).apply!
      node.revise!(content_body: revised_content).apply!
      node.reload
    end

    it 'should patch revisions correctly' do
      expect(node.content_body).to eq revised_content
    end
  end
end
