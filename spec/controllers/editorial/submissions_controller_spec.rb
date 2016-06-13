require 'rails_helper'

RSpec.describe Editorial::SubmissionsController, type: :controller do
  render_views

  let(:node) { Fabricate(:node) }
  let(:user) { Fabricate(:user, author_of: node.section) }

  before { allow(controller).to receive(:current_user) { user.decorate } }

  describe 'GET #new' do
    before { get :new, node_id: node.id }
    it { expect(assigns('node')).to eq node }
  end

  describe 'GET #create' do
    before do
      post :create, node_id: node.id, node: { content_body: 'Submitted change' }
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
