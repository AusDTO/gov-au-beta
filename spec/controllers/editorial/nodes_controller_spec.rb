require 'rails_helper'

RSpec.describe Editorial::NodesController, type: :controller do
  render_views

  let!(:section) { Fabricate(:section) }
  let!(:author) { Fabricate(:user, author_of: section) }

  describe 'GET #index' do
    let(:reviewer) { Fabricate(:user, reviewer_of: section) }
    let(:nodes) { Fabricate.times(3, :node, section: section) }
    let(:authenticated_request) { get :index, params: { section_id: section } }

    context 'when user is authorised' do
      before do
        sign_in(author)
        authenticated_request
      end

      after { sign_out(reviewer) }

      it { is_expected.to assign_to(:section).with section }
      it { is_expected.to assign_to(:nodes).with section.nodes.decorate }
    end

    context 'when user is not authorised' do
      before { authenticated_request }

      it { is_expected.to set_flash[:alert].to("You are not authorized to access this page.") }
    end

    context 'when user is a reviewer' do
      before { sign_in(reviewer) }
      after { sign_out(reviewer) }

      it { is_expected.not_to set_flash[:alert] }
    end

    context 'when user is an author' do
      before { sign_in(author) }
      after { sign_out(author) }

      it { is_expected.not_to set_flash[:alert] }
    end
  end

  describe 'POST #create' do
    before do
      expect(ContentAnalysisHelper).to receive(:lint).and_return('')
    end

    context 'when user is authorised' do
      before { sign_in(author) }

      let(:submission) { Fabricate(:submission) }

      subject do
        post :create, section_id: section, node: { name: 'Test Node' }
        response
      end

      it { is_expected.to redirect_to(editorial_section_submission_path(section, Submission.last)) }

      specify 'that a node is created' do
        expect { subject }.to change(Node, :count).by(1)
      end
    end
  end
end
