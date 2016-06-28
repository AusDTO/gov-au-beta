require 'rails_helper'

RSpec.describe "controls", :type => :feature do
  Warden.test_mode!

  let(:section) { Fabricate(:section) }
  let!(:node) { Fabricate(:node, section: section) }

  context 'not signed in' do
    before do
      visit section_path(section)
    end
    it 'should not show controls' do
      expect(page).to have_no_css('.controls')
    end
  end

  context 'signed in' do
    before do
      login_as(user)
    end

    def controls
      find('.controls')
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
          visit section_path(section)
        end
        include_examples 'no New page link'
        include_examples 'no Edit page link'
      end
    end

    context 'as reviewer' do
      let (:user) { Fabricate(:user, reviewer_of: section) }

      context 'when visiting section' do
        before do
          visit section_path(section)
        end
        include_examples 'no New page link'
        include_examples 'no Edit page link'
      end

      context 'when visiting node' do
        before do
          visit nodes_path(section: section, path: node.path)
        end
        include_examples 'no New page link'
        include_examples 'no Edit page link'
      end
    end

    context 'as author' do
      let (:user) { Fabricate(:user, author_of: section) }

      context 'when visiting section' do
        before do
          visit section_path(section)
        end
        include_examples 'has New page link'
        include_examples 'has Edit page link'
      end

      context 'when visiting node' do
        before do
          visit nodes_path(section: section, path: node.path)
        end
        include_examples 'has New page link'
        include_examples 'has Edit page link'
      end

    end

  end
end