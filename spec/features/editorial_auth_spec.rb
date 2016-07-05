require 'rails_helper'

describe 'editorial authorisation' do
  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let!(:section) { Fabricate(:section, with_home: true) }
  let!(:author_user) { Fabricate(:user, author_of: section) }
  let!(:reviewer_user) { Fabricate(:user, reviewer_of: section) }
  let!(:admin_user) { Fabricate(:user, is_admin: true) }

  shared_examples_for 'not authorized' do
    it 'should have been redirected to root and shown not authorized' do
      expect(page.current_path).to eq('/')
      expect(page).to have_content('You are not authorized to access this page')
    end
  end

  context 'an unauthenticated user' do

    context 'on the editorial dashboard page' do
      before { visit '/editorial' }

      include_examples "not authorized"
    end

    context 'on a section editorial page' do
      before { visit "/editorial/#{section.id}" }

      include_examples "not authorized"
    end

    context 'on the create new content interstitial' do
      before { visit "/editorial/#{section.id}/nodes/prepare" }

      include_examples "not authorized"
    end
  end

  context 'logged in' do

    shared_examples_for 'authorized' do
      it 'should not show not authorized' do
        expect(page).to have_no_content('You are not authorized to access this page')
      end
    end

    context 'as author' do
      before { login_as(author_user, scope: :user) }

      context 'on the editorial dashboard page' do
        before { visit '/editorial' }

        include_examples "authorized"
      end
      context 'on the create new content interstitial' do
        before { visit "/editorial/#{section.id}/nodes/prepare" }

        include_examples "authorized"
      end

      context 'on the create new content page' do
        before { visit "/editorial/#{section.id}/nodes/prepare" }

        include_examples "authorized"
      end


    end

    context 'as reviewer' do
      before { login_as(reviewer_user, scope: :user) }

      context 'on the editorial dashboard page' do
        before { visit '/editorial' }

        include_examples "authorized"
      end

      context 'on the create new content interstitial' do
        before { visit "/editorial/#{section.id}/nodes/prepare" }

        include_examples "not authorized"
      end

    end

    context ' as admin' do
      before { login_as(admin_user, scope: :user) }

      context 'on the editorial dashboard page' do
        before { visit '/editorial' }

        include_examples "authorized"
      end

      context 'on the create new content interstitial' do
        before { visit "/editorial/#{section.id}/nodes/prepare" }

        include_examples "authorized"
      end

      context 'on the create new content page' do
        before { visit "/editorial/#{section.id}/nodes/new" }

        include_examples "authorized"
      end

    end
  end
end
