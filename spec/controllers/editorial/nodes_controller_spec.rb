require 'rails_helper'

#FIXME: restore CAS blocks in POST #create below once CAS is restored

RSpec.describe Editorial::NodesController, type: :controller do
  render_views

  let!(:section) { Fabricate(:section) }
  let!(:section_home) { Fabricate(:section_home, section: section) }

  let(:author) { Fabricate(:user, author_of: section) }

  describe 'GET #index' do
    let(:reviewer) { Fabricate(:user, reviewer_of: section) }
    let(:nodes) { Fabricate.times(3, :general_content, parent: section_home) }
    let(:authenticated_request) { get :index, params: { section_id: section.id } }

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

  describe 'GET #show' do
    let(:node) { Fabricate(:general_content, parent: section_home) }
    before do
      sign_in(author)
      get :show, params: { section_id: section, id: node.id }
    end

    it { is_expected.to assign_to(:node).with node }
  end

  describe 'POST #create' do
    # before do
    #   expect(ContentAnalysisHelper).to receive(:lint).and_return('')
    # end

    describe 'to a collaborate node' do
      context 'as authorised user' do

        before { sign_in(author) }

        let(:submission) { Fabricate(:submission) }

        context 'with valid data' do
          subject do
            post :create, params: {
                section_id: section,
                node: {name: 'Test Node', parent_id: section_home.id, short_summary: 'foo'}
            }
            response
          end

          it { is_expected.to redirect_to(editorial_section_submission_path(section, Submission.last)) }

          specify 'that a node is created' do
            expect { subject }.to change(Node, :count).by(1)
          end
        end

        context 'with an invalid type' do
          subject do
            post :create, params: {
                section_id: section,
                node: {name: 'Test node', parent_id: section.home_node.id, short_summary: 'foo'},
                type: 'bad'
            }
            response
          end

          it { is_expected.to have_http_status(:bad_request) }
        end
      end

      context 'as unauthorised user' do
        let(:user) { Fabricate(:user) }
        before do
          sign_in(user)
        end

        it "does not save the new node" do
          expect{
            post :create, params: {
                section_id: section.id,
                node: { name: 'Test Node', parent_id: section_home.id }
            }
          }.to_not change(Node,:count)
        end
      end
    end
    context 'to a govcms node' do
      let(:section) { Fabricate(:section, cms_type: "govcms" ) }

      context 'as admin user' do
        let(:admin) { Fabricate(:user, is_admin: true) }
        before do
          sign_in(admin)
        end
        it "does not save the new node" do
          expect{
            post :create, params: { section_id: section, node: { name: 'Test Node' } }
          }.to_not change(Node,:count)
        end
      end
    end
  end
end
