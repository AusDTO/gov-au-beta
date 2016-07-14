require 'rails_helper'

RSpec.describe Editorial::SubmissionsController, type: :controller do
  render_views

  describe 'GET #show' do
    context 'as an authorised author' do
      before { sign_in(author) }
      let(:submission) { Fabricate(:submission) }
      let(:section) { submission.revision.revisable.section }
      let!(:author) { Fabricate(:user, author_of: section) }
      subject { get :show, section_id: section, id: submission.id }
      it { is_expected.to be_success }
    end

    context 'as an authorised reviewer' do
      before { sign_in(reviewer) }
      let(:submission) { Fabricate(:submission) }
      let(:section) { submission.revision.revisable.section }
      let!(:reviewer) { Fabricate(:user, reviewer_of: section) }
      subject { get :show, section_id: section, id: submission.id }
      it { is_expected.to be_success }
    end

  end

  describe 'GET #index' do
    # Yes I hate the usage of all of these fabricators...
    let(:user_a) { Fabricate(:user) }
    let(:user_b) { Fabricate(:user) }
    let!(:root_node) { Fabricate(:root_node) }
    let(:section) { Fabricate(:section, with_home: true) }
    let(:section_b) { Fabricate(:section, with_home: true) }
    let(:node_a) { Fabricate(:node, section: section) }
    let(:node_b) { Fabricate(:node, section: section) }
    let(:node_c) { Fabricate(:node, section: section_b ) }
    let(:revision_a) { Fabricate(:revision, revisable: node_a) }
    let(:revision_b) { Fabricate(:revision, revisable: node_b) }
    let(:revision_c) { Fabricate(:revision, revisable: node_c) }

    let!(:submission_a) { Fabricate(:submission, submitter: user_a, revision: revision_a) }
    let!(:submission_b) { Fabricate(:submission, submitter: user_b, revision: revision_b) }
    let!(:submission_c) { Fabricate(:submission, submitter: user_a, revision: revision_c) }

    context 'as user_b on section' do

      before do
        sign_in(user_b)
        get :index, section_id: section
      end

      it 'should return only their submission for section' do
        expect(assigns('submissions')).to eq([submission_b])
      end
    end

    context 'as user_a on section' do

      before do
        sign_in(user_a)
        get :index, section_id: section
      end

      it 'should return only their submission for section' do
        expect(assigns('submissions')).to eq([submission_a])
      end
    end

    context 'as user_a on a different section' do

      before do
        sign_in(user_a)
        get :index, section_id: section_b
      end

      it 'should return only their submission for that section' do
        expect(assigns('submissions')).to eq([submission_c])
      end
    end

  end

  context 'as an author' do
    let(:node) { Fabricate(:node) }
    let(:user) { Fabricate(:user, author_of: node.section) }
    before { sign_in(user) }

    context 'with an open submission' do
      let(:node) { Fabricate(:node) }
      let(:revision) { Fabricate(:revision, revisable: node)}
      let!(:submission) { Fabricate(:submission, revision: revision, submitter: user) }


      describe 'GET #new' do
        before { get :new, section_id: node.section, node_id: node.id }

        it { is_expected.to redirect_to editorial_section_submission_path(node.section, submission) }
      end

      describe 'POST #create' do
        before { post :create, section_id: node.section, node_id: node.id, node: {content_body: 'Some change'}}

        it { is_expected.to redirect_to editorial_section_submission_path(node.section, submission) }

        it 'should not create a submission' do
          sub = Submission.last
          expect(sub).to eq submission
        end
      end

      context 'as another author' do
        let(:user_b) { Fabricate(:user, author_of: node.section) }
        before { sign_in(user_b) }

        describe 'GET #new' do
          before { get :new, section_id: node.section, node_id: node.id }

          it { is_expected.to redirect_to editorial_section_submission_path(node.section, submission) }

        end

        describe 'POST #create' do
          before { post :create, section_id: node.section, node_id: node.id, node: {content_body: 'Some change'} }

          it { is_expected.to redirect_to editorial_section_submission_path(node.section, submission) }

          it 'should not create a submission' do
            sub = Submission.last
            expect(sub).to eq submission
          end
        end
      end

    end

    describe 'GET #new' do
      before { get :new, section_id: node.section, node_id: node.id }
      it { expect(assigns('node')).to eq node }
    end

    describe 'GET #create' do
      before do
        post :create, section_id: node.section, node_id: node.id, node: {content_body: 'Submitted change'}
      end

      it { is_expected.to redirect_to editorial_section_submission_path(node.section, Submission.last) }

      it 'should create a new submission on the node' do
        submission = Submission.last
        expect(submission.revision.revisable).to eq node
      end

      it 'should create a content revision on the newly-created submission' do
        revision = Submission.last.revision
        content = RevisionContent.new(revision)
        expect(content.content_body).to eq 'Submitted change'
      end
    end
  end

  context 'as a reviewer' do
    let!(:submission) { Fabricate(:submission, state: :submitted) }
    let(:user) { Fabricate(:user, reviewer_of: submission.section) }
    before { sign_in(user) }

    describe 'POST #update' do

      context '(:accept)' do
        subject { post :update, section_id: submission.section, id: submission.id, accept: true }
        it { is_expected.to redirect_to nodes_path(submission.revisable.path) }
        it 'change to accepted' do
          expect { subject }.to change { submission.reload.accepted? }.from(false).to(true)
        end
      end

      context '(:reject)' do
        subject { post :update, section_id: submission.section, id: submission.id, reject: true }
        it { is_expected.to redirect_to editorial_section_submission_path(submission.section, submission.id) }
        it 'change to rejected' do
          expect { subject }.to change { submission.reload.rejected? }.from(false).to(true)
        end
      end

      context '()' do
        subject { post :update, section_id: submission.section, id: submission.id }
        it { is_expected.to redirect_to editorial_section_submission_path(submission.section, submission.id) }
        it 'sets flash' do
          subject
          expect(flash[:alert]).to be_present
        end
      end
    end
  end

end
