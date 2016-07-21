require 'rails_helper'

RSpec.describe NewsController, type: :controller do
  render_views

  let!(:root_node) { Fabricate(:root_node) }
  let!(:section_a) { Fabricate(:section) }
  let!(:user) { Fabricate(:user, author_of: section_a) }
  let!(:article_published) { Fabricate(:news_article, section: section_a, state: 'published') }
  let!(:article_draft) { Fabricate(:news_article, section: section_a, state: 'draft') }

  describe 'GET #show' do
    context 'when a user is not authorised' do
      context 'for a published page' do
        before { get :show, section: section_a.home_node.slug, slug: article_published.slug }

        it { expect(response).to be_success }
        it { expect(assigns(:node)).to eq(article_published) }
      end

      context 'for a draft page' do
        it 'should throw a not found' do
          expect {
             get :show, section: section_a.home_node.slug, slug: article_draft.slug
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end