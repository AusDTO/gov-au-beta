require 'rails_helper'

RSpec.describe 'previews', type: :feature do
  include ActionView::Helpers::SanitizeHelper # just for #strip_tags 

  context 'visiting a preview' do
    let(:preview) { Fabricate(:populated_preview) }

    it 'should show the preview' do
      visit "/previews/#{preview.token}"
      expect(page).to have_content preview.name
      expect(page).to have_content strip_tags preview.content_blocks.first['body']
    end

  end

end