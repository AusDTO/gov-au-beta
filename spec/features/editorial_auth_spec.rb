require 'rails_helper'

describe 'editorial authorisation' do
  include Warden::Test::Helpers
  Warden.test_mode!

  let!(:author_user) { Fabricate(:user, is_author: true) }
  let!(:reviewer_user) { Fabricate(:user, is_reviewer: true) }
  let!(:section) { Fabricate(:section) }

  shared_examples_for 'not authorized' do
    it 'should have been redirected to root and shown not authorized' do
      expect(page.current_path).to eq('/')
      page.has_content?('You are not authorized to access this page')
    end
  end

  context 'an unauthenticated user' do

    context 'on the editorial dashboard page' do
      before { visit '/editorial' }

      include_examples "not authorized"
    end

    context 'on a section editorial page' do
      before { visit "/editorial/nodes?section_id=#{section.id}" }

      include_examples "not authorized"
    end

    context 'on the create new content interstitial' do
      before { visit "/editorial/nodes/prepare?section=#{section.id}" }

      include_examples "not authorized"
    end
  end

  context 'logged in' do
    shared_examples_for 'view section links' do
      it 'can select a section' do
        expect(page).to have_link section.name, :href => "/editorial/nodes?section_id=#{section.id}"
      end
    end

    context 'as author' do
      before { login_as(author_user, scope: :user) }

      context 'on the editorial dashboard page' do
        before { visit '/editorial' }

        include_examples 'view section links'
      end
    end

    context 'as reviewer' do
      before { login_as(reviewer_user, scope: :user) }

      context 'on the editorial dashboard page' do
        before { visit '/editorial' }

        include_examples 'view section links'
      end

      context 'on the create new content interstitial' do
        before { visit "/editorial/nodes/prepare?section=#{section.id}" }

        include_examples "not authorized"
      end

    end
  end
end