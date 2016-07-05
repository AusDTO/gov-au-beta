require 'rails_helper'

RSpec.describe "controls", :type => :feature do
  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let(:section) { Fabricate(:section, with_home: true) }
  let!(:node) { section.home_node }

  context 'not signed in' do
    before do
      visit nodes_path(node.path)
    end
    it 'should not show controls' do
      expect(page).to have_no_css('.controls--contrast')
    end
  end

  context 'signed in' do
    before do
      login_as(user)
    end

    def controls
      find('.controls--contrast')
    end

    shared_examples_for 'has New page link' do
      it 'should have New page link' do
        expect(controls).to have_link('New page')
      end
    end

    shared_examples_for 'no New page link' do
      it 'should not have New page link' do
        expect(controls).not_to have_link('New page')
      end
    end

    shared_examples_for 'has Edit page link' do
      it 'should have Edit page link' do
        expect(controls).to have_link('Edit')
      end
    end

    shared_examples_for 'no Edit page link' do
      it 'should not have Edit page link' do
        # expect.not_to have_link('Edit') matches Editorial, so we have to use
        # a regex instead
        expect(controls.find_all('a', :text => /\AEdit\z/)).to be_empty
      end
    end

    context 'as user' do
      let (:user) { Fabricate(:user) }

      context 'when visiting section' do
        before do
          visit nodes_path(section.home_node.path)
        end

        include_examples 'no New page link'
        include_examples 'no Edit page link'
      end

      context 'when visiting a topic page' do
        let(:topic) { Fabricate(:topic) }
        let(:topic_home) { Fabricate(:node, parent: root_node, section: topic) }

        before do
          visit "/#{topic_home.slug}"
        end

        it 'shows a request membership link' do
          expect(page.body).to have_content(/request/i)
        end
      end

      context 'when visiting an agency page' do
        let(:agency) { Fabricate(:agency) }
        let(:agency_home) { Fabricate(:node, parent: root_node, section: agency) }

        before do
          visit nodes_path(agency_home.path)
        end

        it 'does not show request membership link' do
          expect(page.body).not_to have_content(/request/i)
        end
      end
    end

    context 'as reviewer' do
      let (:user) { Fabricate(:user, reviewer_of: section) }

      context 'when visiting node' do
        before do
          visit "/#{node.slug}"
        end

        include_examples 'no New page link'
        include_examples 'no Edit page link'
      end
    end

    context 'as author' do
      let (:user) { Fabricate(:user, author_of: section) }

      context 'when visiting node' do
        before do
          visit "/#{node.slug}"
        end
        include_examples 'has New page link'
        include_examples 'has Edit page link'
      end
    end

    context 'as admin' do
      let (:user) { Fabricate(:user, is_admin: true) }

      context 'when visiting govcms section' do
        let(:section) { Fabricate(:section, cms_type: "govcms", with_home: true) }

        before do
          visit nodes_path(path: section.home_node.path)
        end
        include_examples 'no New page link'
        include_examples 'no Edit page link'
      end
    end
  end
end
