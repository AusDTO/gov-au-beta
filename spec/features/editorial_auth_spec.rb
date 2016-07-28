require 'rails_helper'

describe 'editorial authorisation:' do
  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let!(:section) { Fabricate(:section) }
  let!(:author_user) { Fabricate(:user, author_of: section) }
  let!(:reviewer_user) { Fabricate(:user, reviewer_of: section) }
  let!(:admin_user) { Fabricate(:user, is_admin: true) }
  let!(:no_roles_user) { Fabricate(:user) }

  shared_examples_for 'as not authorized' do
    it 'as not authorized' do
      expect(page.current_path).to eq('/')
      expect(page).to have_content('You are not authorized to access this page')
    end
  end

  shared_examples_for 'as authorized' do
    it 'as authorized' do
      expect(page).to have_no_content('You are not authorized to access this page')
    end
  end

  shared_examples 'verify authorization' do |path_map|
    path_map.each do |path, is_authorized|
      context "on #{path}" do
        before { visit (path % {section_id: section.id, node_id: section.home_node.id}) }
        if is_authorized
          include_examples 'as authorized'
        else
          include_examples 'as not authorized'
        end
      end
    end
  end

  context 'an unauthenticated user' do
    it_behaves_like 'verify authorization', {
        '/editorial'                                => false,
        '/editorial/%{section_id}'                  => false,
        '/editorial/%{section_id}/nodes/prepare'    => false,
        '/editorial/%{section_id}/nodes/new'        => false,
        '/editorial/%{section_id}/nodes/%{node_id}' => false,
        '/editorial/%{section_id}/nodes/%{node_id}/edit' => false,
        '/editorial/%{section_id}/submissions/new?node_id=%{node_id}' => false,
        '/editorial/%{section_id}/requests/new'     => false,
        '/editorial/news'                           => false,
        '/editorial/news/new'                       => false,
    }
  end

  context 'logged in' do
    context 'with no roles' do
      before { login_as(no_roles_user, scope: :user) }
      it_behaves_like 'verify authorization', {
          '/editorial'                                => true,
          '/editorial/%{section_id}'                  => false,
          '/editorial/%{section_id}/nodes/prepare'    => false,
          '/editorial/%{section_id}/nodes/new'        => false,
          '/editorial/%{section_id}/nodes/%{node_id}' => false,
          '/editorial/%{section_id}/nodes/%{node_id}/edit' => false,
          '/editorial/%{section_id}/submissions/new?node_id=%{node_id}' => false,
          '/editorial/%{section_id}/requests/new'     => true,
          '/editorial/news'                           => true,
          '/editorial/news/new'                       => false,
      }
    end

    context 'as author' do
      before { login_as(author_user, scope: :user) }
      it_behaves_like 'verify authorization', {
          '/editorial'                                => true,
          '/editorial/%{section_id}'                  => true,
          '/editorial/%{section_id}/nodes/prepare'    => true,
          '/editorial/%{section_id}/nodes/new'        => true,
          '/editorial/%{section_id}/nodes/%{node_id}' => true,
          '/editorial/%{section_id}/nodes/%{node_id}/edit' => true,
          '/editorial/%{section_id}/submissions/new?node_id=%{node_id}' => true,
          '/editorial/%{section_id}/requests/new'     => true,
          '/editorial/news'                           => true,
          '/editorial/news/new'                       => true,
      }
    end

    context 'as reviewer' do
      before { login_as(reviewer_user, scope: :user) }
      it_behaves_like 'verify authorization', {
          '/editorial'                                => true,
          '/editorial/%{section_id}'                  => true,
          '/editorial/%{section_id}/nodes/prepare'    => false,
          '/editorial/%{section_id}/nodes/new'        => false,
          '/editorial/%{section_id}/nodes/%{node_id}' => true,
          '/editorial/%{section_id}/nodes/%{node_id}/edit' => false,
          '/editorial/%{section_id}/submissions/new?node_id=%{node_id}' => false,
          '/editorial/%{section_id}/requests/new'     => true,
          '/editorial/news'                           => true,
          '/editorial/news/new'                       => false,
      }
    end

    context 'as admin' do
      before { login_as(admin_user, scope: :user) }
      it_behaves_like 'verify authorization', {
          '/editorial'                                => true,
          '/editorial/%{section_id}'                  => true,
          '/editorial/%{section_id}/nodes/prepare'    => true,
          '/editorial/%{section_id}/nodes/new'        => true,
          '/editorial/%{section_id}/nodes/%{node_id}' => true,
          '/editorial/%{section_id}/nodes/%{node_id}/edit' => true,
          '/editorial/%{section_id}/submissions/new?node_id=%{node_id}' => true,
          '/editorial/%{section_id}/requests/new'     => true,
          '/editorial/news'                           => true,
          '/editorial/news/new'                       => true,
      }
    end
  end
end
