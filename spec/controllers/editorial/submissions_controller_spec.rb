require 'rails_helper'

RSpec.describe Editorial::SubmissionsController, type: :controller do
  render_views

  let(:node) { Fabricate(:node) }

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
