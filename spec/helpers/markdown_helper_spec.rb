require 'rails_helper'
include MarkdownHelper

RSpec.describe MarkdownHelper do

  describe '#markdown_content' do
    context 'renders markdown' do
      subject { markdown_content('# Heading') }
      it { is_expected.to have_css('h1') }
    end

    context 'renders consecutive headings' do
      subject { markdown_content("# Heading\n## Heading 2") }
      it { is_expected.to have_css('h2') }
    end

    context 'renders tables' do
      subject { markdown_content("| h1 | h2 |\n|---|---|\n| c1 | c2 |") }
      it { is_expected.to have_css('table') }
      it { is_expected.to have_css('table.content-table') }
    end

    context 'strips script tags' do
      subject { markdown_content('Stuff<script>alert()</script>') }
      it { is_expected.to match('Stuff') }
      it { is_expected.not_to have_css('script') }
    end

    context 'handles no content' do
      subject { markdown_content(nil) }
      it { is_expected.to be_blank }
    end

    context 'handles tel: telephone links' do
      subject { markdown_content('<a href="tel:133 677">National Relay Service - TTY/voice calls</a>')}
      it {is_expected.to have_link('National Relay Service - TTY/voice calls',
                                   :href => "tel:133%20677")}
    end

    context 'creates toc data' do
      subject { markdown_content("## heading one\n## heading two") }
      it { is_expected.to have_css('#heading-one') }
      it { is_expected.to have_css('#heading-two') }
    end
  end

  describe '#markdown_toc' do
    context 'creates an html list of headings' do
      subject { markdown_toc("## heading one\n## heading two") }
      it { is_expected.to have_css('ul') }
      it { is_expected.to have_link('heading one', href: '#heading-one') }
      it { is_expected.to have_link('heading two', href: '#heading-two') }
    end

    context 'stops at h2 by default' do
      subject { markdown_toc("## heading one\n### heading two") }
      it { is_expected.to have_css('ul') }
      it { is_expected.to have_link('heading one', href: '#heading-one') }
      it { is_expected.not_to have_link('heading two') }
    end

    context 'sets nesting level' do
      subject { markdown_toc("## heading one\n### heading two", 3) }
      it { is_expected.to have_css('ul') }
      it { is_expected.to have_link('heading one', href: '#heading-one') }
      it { is_expected.to have_link('heading two', href: '#heading-two') }
    end
  end
end