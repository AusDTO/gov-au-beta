require 'rails_helper'

RSpec.describe Editorial::SubmissionsController, type: :controller do
  include ::NodesHelper
  render_views

  describe 'GET #show' do
    context 'as an authorised author' do
      before { sign_in(author) }

      let!(:section)      { Fabricate(:section) }
      let!(:section_home) { Fabricate(:section_home, section: section) }
      let!(:node)         { Fabricate(:general_content, parent: section_home) }

      let(:submission) { Fabricate(:submission, revisable: node) }
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
    let(:flora) { Fabricate(:section) }
    let(:flora_home) { Fabricate(:section_home, section: flora) }
    let(:fauna) { Fabricate(:section) }
    let(:fauna_home) { Fabricate(:section_home, section: fauna) }
    let(:author) { Fabricate(:user, author_of: [flora, fauna]) }
    let(:flora_reviewer) { Fabricate(:user, author_of: [flora, fauna], reviewer_of: flora) }
    let(:tree) { Fabricate(:general_content, parent: flora_home) }
    let(:grass) { Fabricate(:general_content, parent: flora_home) }
    let(:cow) { Fabricate(:general_content, parent: fauna_home ) }
    let(:goat) { Fabricate(:general_content, parent: fauna_home ) }
    let(:revision_tree) { Fabricate(:revision, revisable: tree) }
    let(:revision_grass) { Fabricate(:revision, revisable: grass) }
    let(:revision_cow) { Fabricate(:revision, revisable: cow) }
    let(:revision_goat) { Fabricate(:revision, revisable: goat) }
    let!(:submission_tree) { Fabricate(:submission, submitter: author, revision: revision_tree) }
    let!(:submission_grass) { Fabricate(:submission, submitter: flora_reviewer, revision: revision_grass) }
    let!(:submission_cow) { Fabricate(:submission, submitter: author, revision: revision_cow) }
    let!(:submission_goat) { Fabricate(:submission, submitter: flora_reviewer, revision: revision_goat) }

    before do
      sign_in user
      get :index, section_id: section
    end

    subject { assigns 'submissions' }

    context 'as author on flora' do
      let(:user) { author }
      let(:section) { flora }
      it { is_expected.to eq [submission_tree] }
    end

    context 'as author on fauna' do
      let(:user) { author }
      let(:section) { fauna }
      it { is_expected.to eq [submission_cow] }
    end

    context 'as flora reviewer on flora' do
      let(:user) { flora_reviewer }
      let(:section) { flora }
      it { is_expected.to eq [submission_grass, submission_tree] }
    end

    context 'as flora reviewer on fauna' do
      let(:user) { flora_reviewer }
      let(:section) { fauna }
      it { is_expected.to eq [submission_goat] }
    end
  end

  context 'as an author' do
    let(:node) { Fabricate(:general_content) }
    let(:user) { Fabricate(:user, author_of: node.section) }
    before { sign_in(user) }

    context 'with an open submission' do
      let(:node) { Fabricate(:general_content) }
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
        it { is_expected.to redirect_to public_node_path(submission.revisable) }
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
