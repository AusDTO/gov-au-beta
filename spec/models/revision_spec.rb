require 'rails_helper'

RSpec.describe Revision, type: :model do
  describe 'scopes' do
    let(:node) { Fabricate(:node) }
    let!(:first_pending_revision) { Fabricate(:revision, revisable: node, created_at: 2.days.ago) }
    let!(:second_pending_revision) { Fabricate(:revision, revisable: node, created_at: 1.day.ago) }
    let!(:first_applied_revision) { Fabricate(:revision, revisable: node, applied_at: 4.days.ago) }
    let!(:second_applied_revision) { Fabricate(:revision, revisable: node, applied_at: 4.days.ago) }

    it 'should flag instances' do
      expect(first_pending_revision).to be_pending
      expect(first_applied_revision).to be_applied
    end

    describe 'applied' do
      subject { node.revisions.applied }

      it { is_expected.to eq [second_applied_revision, first_applied_revision] }
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

  describe '#apply!' do
    let(:node) { Fabricate(:node, content_body: 'initial content') }
    let(:revision) { node.revise! content_body: 'changed content' }

    context 'before applying revision' do
      it 'should not affect node content' do
        expect(node.content_body).to eq 'initial content'
      end
    end

    context 'after applying revision' do
      before do
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
end
