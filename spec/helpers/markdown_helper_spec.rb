require 'rails_helper'
include MarkdownHelper

RSpec.describe MarkdownHelper do

  describe '#markdown_to_html' do
    context 'renders markdown' do
      subject { markdown_to_html('# Heading') }
      it { is_expected.to match('<h1>') }
    end

    context 'renders consecutive headings' do
      subject { markdown_to_html("# Heading\n## Heading 2") }
      it { is_expected.to match('<h2>') }
    end

    context 'renders tables' do
      subject { markdown_to_html("| h1 | h2 |\n|---|---|\n| c1 | c2 |") }
      it { is_expected.to have_css('table') }
      it { is_expected.to have_css('table.content-table') }
    end

    context 'strips script tags' do
      subject { markdown_to_html('Stuff<script>alert()</script>') }
      it { is_expected.to match('Stuff') }
      it { is_expected.not_to have_css('script') }
    end

    context 'handles no content' do
      subject { markdown_to_html(nil) }
      it { is_expected.to be_blank }
    end

    context 'handles tel: telephone links' do
      subject { markdown_to_html('<a href="tel:133 677">National Relay Service - TTY/voice calls</a>')}
      it {is_expected.to have_link('National Relay Service - TTY/voice calls',
                                   :href => "tel:133%20677")}
    end
  end
end