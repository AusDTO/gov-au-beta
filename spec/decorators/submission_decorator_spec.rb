require 'rails_helper'

RSpec.describe SubmissionDecorator, type: :decorator do

  let!(:root_node) { Fabricate(:root_node) }

  describe '#submitted_content' do
    subject { Fabricate(:submission).decorate.submitted_content }
    it { is_expected.to be_a(RevisionContent) }
  end

  describe '#original_content' do
    let(:grand_parent) { Fabricate(:submission) }
    let(:parent) { Fabricate(:submission, revision: grand_parent.revisable.revise!(content_body: 'parent content')) }
    let(:child) { Fabricate(:submission, revision: parent.revisable.revise!(content_body: 'child content'))}

    before do
      grand_parent.submit!(grand_parent.submitter)
      grand_parent.accept!(grand_parent.submitter)
    end

    context 'without applied content' do
      let(:new_page_submission) { Fabricate(:submission) }
      subject { new_page_submission.decorate.original_content }
      it { is_expected.to be_nil }
    end

    context 'with applied parent' do
      subject { parent.decorate.original_content }
      it { is_expected.to be_a(RevisionContent) }
      it { expect(subject.content_body).to eq(grand_parent.decorate.submitted_content.content_body) }
      it { expect(subject.content_body).not_to eq(parent.decorate.submitted_content.content_body) }
    end

    context 'with applied grandparent' do
      subject { child.decorate.original_content }
      it { is_expected.to be_a(RevisionContent) }
      it { expect(subject.content_body).to eq(grand_parent.decorate.submitted_content.content_body) }
      it { expect(subject.content_body).not_to eq(child.decorate.submitted_content.content_body) }
    end
  end
end
