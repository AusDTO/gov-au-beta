require 'rails_helper'

RSpec.describe Editorial::NewsController, type: :controller do
  include ::NodesHelper
  render_views

  let!(:root_node) { Fabricate(:root_node) }
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
    context 'when a user is authorised' do
      context 'with valid date' do

        let(:post_action) {
          post :create, node: {
            name: 'Test',
            section_id: section_a.id,
            short_summary: 'foo',
            summary: 'bar',
            content_body: 'foobar',
            release_date: Date.today,
            section_ids: [section_b.id]
          }
        }

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

      context 'create with invalid publisher' do
        before do
          sign_in(user)
        end
        subject {
          post :create, node: {
              name: 'Foo',
              section_id: section_c.id,
              short_summary: 'foo',
              summary: 'bar',
              content_body: 'body',
              release_date: Time.now.to_s,
              section_ids: [section_a.id]
          }
        }

        it { is_expected.to render_template :new }
      end
    end

    context 'when a user is not authorised' do
      let(:post_action) {
        post :create, node: {
            name: 'Test',
            section_id: section_a.id,
            short_summary: 'foo',
            summary: 'bar',
            content_body: 'foobar',
            release_date: Date.today,
            section_ids: [section_b.id]
        }
      }
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

  describe '#update' do

    let!(:article) { Fabricate(:news_article, section: section_a, release_date: Date.yesterday) }

    context 'when a user is authenticated' do
      before { sign_in(user) }

      context 'updating to valid publisher' do
        let!(:post_action) {
          post :update, id: article.id, node: {
            section_id: section_b,
            release_date: Date.today
          }
        }

        it { is_expected.to redirect_to public_node_path(NewsArticle.find(article.id)) }

        it 'should update the news article' do
          news = NewsArticle.find(article.id)
          expect(news.release_date).to eq Date.today
          expect(news.section_id).to eq section_b.id
        end
      end

      context 'update to an invalid publisher' do
        let!(:post_action) {
          post :update, id: article.id, node: {
            section_id: section_c
          }
        }

        it { is_expected.to render_template :edit }
      end

      context 'update distribution list' do
        let!(:post_action) {
          post :update, id: article.id, node: {
            section_ids: [section_b.id, section_c.id]
          }
        }

        it { is_expected.to redirect_to public_node_path(article) }

        it 'should reject sections without membership' do
          news = NewsArticle.find(article.id)
          expect(news.section_ids).to eq [section_b.id]
        end
      end
    end

    context 'when a user is not authenticated' do
      let!(:post_action) {
        post :update, id: article.id, node: {
          section_id: section_a
        }
      }

      it { is_expected.to redirect_to root_path }
      it { is_expected.to set_flash[:alert].to('You are not authorized to access this page.') }
    end
  end
end
