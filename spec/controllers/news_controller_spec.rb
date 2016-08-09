require 'rails_helper'

RSpec.describe NewsController, type: :controller do
  render_views

  let!(:section_a) { Fabricate(:section) }
  let!(:section_home) { Fabricate(:section_home, section: section_a) }
  let!(:user) { Fabricate(:user, author_of: section_a) }

  describe 'GET #show' do
    let!(:article_published) { Fabricate(:news_article, parent: section_home, state: 'published') }
    let!(:article_draft) { Fabricate(:news_article, parent: section_home, state: 'draft') }

    context 'when a user is not authorised' do
      context 'for a published page' do
        before { get :show, section: section_a.slug, slug: article_published.slug }

        it { expect(response).to be_success }
        it { expect(assigns(:node)).to eq(article_published) }
      end

      context 'for a draft page' do
        it 'should throw a not found' do
          expect {
             get :show, section: section_a.slug, slug: article_draft.slug
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'for an undefined section' do
        it 'should throw a not found' do
          expect {
            get :show, section: 'undefined', slug: article_draft.slug
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe 'GET #index' do
    let!(:article_unpub) { Fabricate(:news_article, state: 'draft') }
    let(:in_the_past) { 10.minutes.ago }
    let(:date_today) { Date.today }
    let(:date_yesterday) { date_today - 24.hours }
    let!(:article_today_a) {
      Fabricate(:news_article, state: 'published', release_date: date_today, name: 'A', published_at: in_the_past)
    }
    let!(:article_today_b) {
      Fabricate(:news_article, state: 'published', release_date: date_today, name: 'B', published_at: in_the_past)
    }
    let!(:article_today_c) {
      Fabricate(:news_article, state: 'published', release_date: date_today, name: 'C', published_at: Time.now.utc)
    }
    let!(:article_yesterday) { Fabricate(:news_article, state: 'published', release_date: date_yesterday) }

    context 'when a user is not authorised' do
      before { get :index }

      it { expect(response).to be_success }

      it 'should not return draft articles' do
        expect(assigns(:articles)).to_not include(article_unpub)
      end

      it 'should return a list ordered by date and name' do
        expect(assigns(:articles).to_a).to eq([article_today_c, article_today_a, article_today_b, article_yesterday])
      end
    end
  end
end
