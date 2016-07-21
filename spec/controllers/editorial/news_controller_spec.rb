require 'rails_helper'

RSpec.describe Editorial::NewsController, type: :controller do
  render_views

  let!(:root_node) { Fabricate(:root_node) }
  let!(:news) { Fabricate(:section, name: 'news') }
  let!(:section_a) { Fabricate(:section) }
  let!(:section_b) { Fabricate(:section) }
  let!(:section_c) { Fabricate(:section) }
  let!(:user) { Fabricate(:user, author_of: section_a, reviewer_of: section_b) }

  describe 'GET #new' do
    context 'when a user is authorised' do
      before { sign_in(user) }

      context 'with a blank form' do
        subject { get :new }

        it { is_expected.to be_success }
      end
    end

    context 'when a user is not authorised' do
      before { get :new }

      it { is_expected.to redirect_to(root_path) }
      it { is_expected.to set_flash[:alert].to('You are not authorized to access this page.') }
    end
  end

  describe 'POST #create' do
    let(:post_action) {
      post :create, node: {
        name: 'Test',
        section_id: section_a.id,
        short_summary: 'foo',
        summary: 'bar',
        content_body: 'foobar',
        release_date: Time.now.to_s,
        section_ids: [section_b.id]
      }
    }

    context 'when a user is authorised' do
      before do
        sign_in(user)
        post_action
      end

      it 'should not have a parent' do
        expect(Node.last.parent).to eq(nil)
      end

      it 'should have the publisher section as node section' do
        expect(Node.last.section).to eq(section_a)
      end

      it { is_expected.to set_flash[:notice].to('Your changes have been submitted') }
      it { is_expected.to redirect_to(editorial_section_submission_path(section_a.id, Submission.last)) }
    end

    context 'when a user is not authorised' do
      let!(:submission) { Fabricate(:submission) }
      before do
        post_action
      end

      it { is_expected.to set_flash[:alert].to('You are not authorized to access this page.') }
      it { is_expected.to redirect_to(root_path) }

      it 'should not create a submission' do
        expect {
          post_action
        }.to_not change(Submission, :count)
      end

      it 'should not create a node' do
        expect {
          post_action
        }.to_not change(Node, :count)
      end
    end
  end
end