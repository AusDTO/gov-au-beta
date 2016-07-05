require 'rails_helper'

RSpec.describe NodeCreator, type: :service do
  let!(:root_node)   { Fabricate(:root_node) }
  let(:user)         { Fabricate(:user) }
  let!(:section)     { Fabricate(:section) }
  let!(:parent)      { Fabricate(:node, section: section, parent: root_node) }
  let(:name)         { 'Node Name' }
  let(:content_body) { 'This is the first revision' }
  let(:node_class)   { Node }
  let(:form)         { NodeForm.new(node_class.new(params)) }
  let(:params)       { { name: name, content_body: content_body,
                         parent_id: parent.id } }

  subject(:creator)  { NodeCreator.new(section, form) }

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

      specify 'that the revision content matches the name' do
        expect(RevisionContent.new(revision).all_content[:name]).to eq(name)
      end

      describe 'the created node' do
        subject(:node) { revision.revisable }
        it { is_expected.to be_a(Node) }

        specify { expect(subject.section).to eq(section) }
        specify { expect(subject.parent).to eq(parent) }

        context 'when node class is General Content' do
          let(:node_class) { GeneralContent }
          it { is_expected.to be_a(GeneralContent) }
        end
      end
    end
  end
end
