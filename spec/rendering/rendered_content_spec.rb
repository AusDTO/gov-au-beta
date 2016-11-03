require 'rails_helper'

# set type to helper to include capybara matchers
RSpec.describe RenderedContent, type: :helper do

  let(:node) { Fabricate(:general_content, options: {toc: 2}) }
  let(:h) { ViewHelpers.instance }

  before do
    #node.options.toc = 2
    node.content_body = raw
  end

  describe '#content' do

    subject { node.decorate.rendered[:content_body].content }

    context 'renders markdown' do
      let(:raw) { '# Heading' }
      it { is_expected.to have_css('h1') }
    end

    context 'renders consecutive headings' do
      let(:raw) { "# Heading\n## Heading 2" }
      it { is_expected.to have_css('h2') }
    end

    context 'renders tables' do
      let(:raw) { "| h1 | h2 |\n|---|---|\n| c1 | c2 |" }
      it { is_expected.to have_css('table') }
      it { is_expected.to have_css('table.content-table') }
    end
    
    context 'renders links' do
      let(:raw) { '[a link](http://example.com)' }
      it { is_expected.to have_link('a link', href: 'http://example.com') }
    end
    
    context 'renders links with a quote' do
      let(:raw) { '[a "link"](http://example.com)' }
      it { is_expected.to have_link('a "link"', href: 'http://example.com') }
    end
    
    context 'renders links with an apostrophe' do
      let(:raw) { "[a link's text](http://example.com)" }
      it { is_expected.to have_link("a link's text", href: 'http://example.com') }
    end

    context 'renders links with a space' do
      let(:raw) { '[a link](http://example.com/a thing)' }
      it { is_expected.to have_link('a link', href: 'http://example.com/a%20thing') }
    end

    context 'renders links with an img' do
      let(:raw) { '[![Foo](https://example.com/image.png)](http://example.com)' }
      it { is_expected.to match('<a href="http://example.com"><img src="https://example.com/image.png" alt="Foo"></a>') }
    end

    context 'renders links without script' do
      let(:raw) { '[<script>alert("Foo")</script>](http://example.com)' }
      it { is_expected.not_to have_css('script') }
    end

    context 'renders links without iframe' do
      let(:raw) { '[<iframe src="https://bad.com/">foo</iframe>](http://example.com)' }
      it { is_expected.not_to have_css('iframe') }
    end

    context 'strips script tags' do
      let(:raw) { 'Stuff<script>alert()</script>' }
      it { is_expected.to match('Stuff') }
      it { is_expected.not_to have_css('script') }
    end

    context 'handles no content' do
      let(:raw) { nil }
      it { is_expected.to be_blank }
    end

    context 'handles tel: telephone links' do
      let(:raw) { '<a href="tel:133 677">National Relay Service - TTY/voice calls</a>' }
      it { is_expected.to have_link('National Relay Service - TTY/voice calls',
                                    :href => "tel:133%20677") }
    end

    context 'creates toc data' do
      let(:raw) { "## heading one\n\n## heading two" }
      it { is_expected.to have_css('#heading-one') }
      it { is_expected.to have_css('#heading-two') }
    end

    context 'liquid' do
      let (:link_target) { Fabricate(:general_content) }
      let (:placeholder_target) { Fabricate(:general_content, placeholder: true) }

      context 'with valid node id' do
        context 'creates node links' do
          let(:raw) { "{{ nodes['#{link_target.token}'].link_to }}" }
          it { is_expected.to have_link(link_target.name, href: h.public_node_path(link_target)) }

          context 'with custom text' do
            let(:raw) { "{{ 'Custom text' | link_to_node: nodes['#{link_target.token}'}}" }
            it { is_expected.to have_link('Custom text', href: h.public_node_path(link_target)) }
          end
        end

        context 'to a placeholder node' do
          context 'creates placeholder spans' do
            let(:raw) { "{{ nodes['#{placeholder_target.token}'].link_to }}" }
            it { is_expected.to have_css('span.placeholder-link') }
          end
        end

        context 'inserts node name' do
          let(:raw) { "{{ nodes['#{link_target.token}'].name }}" }
          it { is_expected.to have_content(link_target.name) }
        end
      end

      context 'with an invalid node id' do
        let(:raw) { "{{ nodes['bad'].link_to }}" }
        it { is_expected.to have_css('span.liquid-error') }
      end

    end
  end

  describe '#toc' do
    subject { node.decorate.rendered[:content_body].content }

    context 'creates an html list of headings' do
      let(:raw) { "## heading one\n\n## heading two" }
      it { is_expected.to have_css('ul') }
      it { is_expected.to have_link('heading one', href: '#heading-one') }
      it { is_expected.to have_link('heading two', href: '#heading-two') }
    end

    context 'sets nesting level' do
      before { node.options.toc = 3 }
      let(:raw) { "## heading one\n\n### heading two" }
      it { is_expected.to have_css('ul') }
      it { is_expected.to have_link('heading one', href: '#heading-one') }
      it { is_expected.to have_link('heading two', href: '#heading-two') }
    end
  end
end