require 'rails_helper'

RSpec.describe Editorial::SubmissionsController, type: :controller do
  render_views

  let(:node) { Fabricate(:node) }

  describe 'GET #index' do
    let(:user_a) { Fabricate(:user) }
    let(:user_b) { Fabricate(:user) }
    let(:section) { Fabricate(:section) }
    let(:node_a) { Fabricate(:node, section: section) }
    let(:node_b) { Fabricate(:node, section: section) }
    let(:revision_a) { Fabricate(:revision, revisable: node_a) }
    let(:revision_b) { Fabricate(:revision, revisable: node_b) }

    let!(:submission_a) { Fabricate(:submission, submitter: user_a) }
    let!(:submission_b) { Fabricate(:submission, submitter: user_b, revision: revision_a) }
    let!(:submission_c) { Fabricate(:submission, submitter: user_a, revision: revision_b) }

    context 'as user_a' do

      before do
        sign_in(user_a)
        get :index
      end

      it 'should return only their submission' do
        expect(assigns('existing_submissions')).to eq([submission_c, submission_a])
      end
    end

    context 'as user_b on section' do

      before do
        sign_in(user_b)
        get :index, section: section.slug
      end

      it 'should return only their submission for section' do
        expect(assigns('existing_submissions')).to eq([submission_b])
      end
    end

    context 'as user_c on section' do

      before do
        sign_in(user_a)
        get :index, section: section.slug
      end

      it 'should return only their submission for section' do
        expect(assigns('existing_submissions')).to eq([submission_c])
      end
    end

  end

  context 'as an author' do
    let(:user) { Fabricate(:user, author_of: node.section) }
    before { sign_in(user) }

    describe 'GET #new' do
      before { get :new, node_id: node.id }
      it { expect(assigns('node')).to eq node }
    end

    describe 'GET #create' do
      before do
        post :create, node_id: node.id, node: {content_body: 'Submitted change'}
      end

      it { is_expected.to redirect_to editorial_submission_path(Submission.last) }

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

    describe 'GET #show' do
      before { get :show, id: submission.id }
      let!(:submission) { Fabricate(:submission) }

      it { expect(assigns('submission')).to eq submission }
    end
  end

  context 'as a reviewer' do
    let!(:submission) { Fabricate(:submission, state: :submitted) }
    let(:user) { Fabricate(:user, reviewer_of: submission.section) }
    before { sign_in(user) }

    describe 'POST #update' do

      context '(:accept)' do
        subject { post :update, id: submission.id, accept: true }
        it { is_expected.to redirect_to editorial_submission_path(submission.id) }
        it 'change to accepted' do
          expect { subject }.to change { submission.reload.accepted? }.from(false).to(true)
        end
      end

      context '(:reject)' do
        subject { post :update, id: submission.id, reject: true }
        it { is_expected.to redirect_to editorial_submission_path(submission.id) }
        it 'change to rejected' do
          expect { subject }.to change { submission.reload.rejected? }.from(false).to(true)
        end
      end
    end
  end

end
