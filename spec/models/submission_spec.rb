require 'rails_helper'

RSpec.describe Submission, type: :model do

  it { is_expected.to belong_to :revision }
  it { is_expected.to belong_to :submitter }
  it { is_expected.to belong_to :reviewer }

  it { is_expected.to validate_presence_of :revision }
  it { is_expected.to validate_presence_of :submitter }
  it { is_expected.not_to validate_presence_of :reviewer }

  describe 'scopes' do
    let(:private_draft) { Fabricate(:submission) }
    let(:submitted_draft) { Fabricate(:submission, submitted_at: 2.days.ago, state: :submitted) }
    let(:rejected) { Fabricate(:submission, reviewed_at: 2.days.ago, state: :rejected) }
    let(:accepted) { Fabricate(:submission, reviewed_at: 2.days.ago, state: :accepted)}

    describe 'draft' do
      subject { Submission.with_state(:draft) }
      it { is_expected.to eq [private_draft] }
    end

    describe 'submitted drafts' do
      subject { Submission.with_state(:submitted) }
      it { is_expected.to eq [submitted_draft] }
    end

    describe 'accepted' do
      subject { Submission.with_state(:accepted) }
      it { is_expected.to eq [accepted] }
    end

    describe 'rejected' do
      subject { Submission.with_state(:rejected) }
      it { is_expected.to eq [rejected] }
    end
  end

  describe '#submit!' do
    context 'editing body' do
      let(:author) { Fabricate(:user, reviewer_of: revision.section) }
      let(:revision) { Fabricate(:node).revise! content_body: 'Revised content' }
      subject { Fabricate(:submission, revision: revision) }
      before do
        subject.submit! author
      end
      it { is_expected.to be_submitted }
      it { expect(subject.submitted_at).to be_present }
      it { expect(revision.revisable.content_body).not_to eq 'Revised content' }
    end
    context 'editing title' do
      let(:author) { Fabricate(:user, reviewer_of: revision.section) }
      let(:revision) { Fabricate(:node).revise! name: 'Revised name' }
      subject { Fabricate(:submission, revision: revision) }
      before do
        subject.submit!(author)
      end
      it { is_expected.to be_submitted }
      it { expect(subject.submitted_at).to be_present }
      it { expect(revision.revisable.name).not_to eq 'Revised name' }
    end
    context 'editing title and content' do
      let(:author) { Fabricate(:user, reviewer_of: revision.section) }
      let(:revision) { Fabricate(:node).revise!(name: 'Revised name', content_body: 'Revised content') }
      subject { Fabricate(:submission, revision: revision) }
      before do
        subject.submit!(author)
      end
      it { is_expected.to be_submitted }
      it { expect(subject.submitted_at).to be_present }
      it { expect(revision.revisable.content_body).not_to eq 'Revised content' }
      it { expect(revision.revisable.name).not_to eq 'Revised name' }
    end
  end


  describe 'reviewing' do
    let(:reviewer) { Fabricate(:user, reviewer_of: revision.section) }
    let(:revision) { Fabricate(:node, state: 'draft').revise! name: 'Revised name', content_body: 'Revised content' }
    subject { Fabricate(:submission, revision: revision, submitted_at: 3.days.ago, state: :submitted) }

    before do
      review_it
    end

    context 'rejection' do
      let(:review_it) { subject.reject! reviewer }

      it { expect(subject).to be_rejected }
      it { expect(subject.reviewed_at).to be_present }
      it { expect(revision.revisable.content_body).not_to eq 'Revised content' }
      it { expect(revision.revisable.name).not_to eq 'Revised name' }
      it { expect(revision.revisable.state).to eq 'draft' }
    end

    context 'acceptance' do
      let(:review_it) { subject.accept! reviewer }

      it { expect(subject).to be_accepted }
      it { expect(subject.reviewed_at).to be_present }
      it { expect(revision.revisable.content_body).to eq 'Revised content' }
      it { expect(revision.revisable.name).to eq 'Revised name' }
      it { expect(revision.revisable.state).to eq 'published' }
    end


  end
end
