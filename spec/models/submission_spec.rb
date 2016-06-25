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
    let(:submitted_draft) { Fabricate(:submission, submitted_at: 2.days.ago) }
    let(:rejected) { Fabricate(:submission, reviewed_at: 2.days.ago) }
    let(:accepted) { Fabricate(:submission, reviewed_at: 2.days.ago,
      accepted: true)}

    describe 'draft' do
      subject { Submission.draft }
      it { is_expected.to eq [private_draft, submitted_draft] }
    end

    describe 'unsubmitted drafts' do
      subject { Submission.unsubmitted.draft }
      it { is_expected.to eq [private_draft] }
    end

    describe 'submitted drafts' do
      subject { Submission.submitted.draft }
      it { is_expected.to eq [submitted_draft] }
    end

    describe 'reviewed' do
      subject { Submission.reviewed }
      it { is_expected.to eq [accepted, rejected] }
    end

    describe 'accepted' do
      subject { Submission.accepted }
      it { is_expected.to eq [accepted] }
    end

    describe 'rejected' do
      subject { Submission.rejected }
      it { is_expected.to eq [rejected] }
    end
  end

  describe 'reviewing' do
    let(:reviewer) { Fabricate(:user, reviewer_of: revision.revisable.section) }
    let(:revision) { Fabricate(:node).revise! content_body: 'Revised content' }
    subject { Fabricate(:submission, revision: revision, submitted_at: 3.days.ago) }

    before do
      review_it
    end

    context 'rejection' do
      let(:review_it) { subject.reject! reviewer }

      it { expect(subject).to be_rejected }
      it { expect(subject.reviewed_at).to be_present }
      it { expect(revision.revisable.content_body).not_to eq 'Revised content' }
    end

    context 'acceptance' do
      let(:review_it) { subject.accept! reviewer }

      it { expect(subject).to be_accepted }
      it { expect(subject.reviewed_at).to be_present }
      it { expect(revision.revisable.content_body).to eq 'Revised content' }
    end
  end
end
