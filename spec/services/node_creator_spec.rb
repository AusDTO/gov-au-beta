require 'rails_helper'

RSpec.describe NodeCreator, type: :service do
  let(:user)         { Fabricate(:user) }
  let!(:section)     { Fabricate(:section) }
  let!(:parent)      { Fabricate(:node) }
  let(:name)         { 'Node Name' }
  let(:content_body) { 'This is the first revision' }
  let(:params)       { { name: name, content_body: content_body } }
  let(:node_class)   { Node }
  let(:form)         { NodeForm.new(node_class.new(params)) }
  
  subject(:creator)  { described_class.new(section, form) }

  it 'creates a new node' do
    expect { subject.perform!(user) }.to change(Node, :count).by(1)
  end

  describe 'the created submission' do
    subject(:submission) { creator.perform!(user) }

    it { is_expected.to be_a(Submission) }
    it { is_expected.to be_submitted }

    it 'has the user set as the submitter' do
      expect(submission.submitter).to eq(user)
    end

    describe 'the created revision' do
      subject(:revision) { submission.revision }

      it { is_expected.to be_a(Revision) }
      it { is_expected.to be_pending }

      it 'has a submission' do
        expect(revision.submission).to be_a(Submission)
      end

      specify 'that the revision content matches the content body' do
        expect(RevisionContent.new(revision).all_content[:content_body]).to eq(content_body)
      end

      describe 'the created node' do
        subject(:node) { revision.revisable }
        it { is_expected.to be_a(Node) }

        specify { expect(subject.section).to eq(section) }
        specify { expect(subject.name).to eq(name) }

        context 'when a parent is specified' do
          before { params.merge!(parent_id: parent.id) }
          specify { expect(subject.parent).to eq(parent) }
        end

        context 'when node class is General Content' do
          let(:node_class) { GeneralContent }
          it { is_expected.to be_a(GeneralContent) }
        end
      end
    end
  end
end
