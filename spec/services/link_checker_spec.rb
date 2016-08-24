require 'rails_helper'

RSpec.describe ApplicationController, type: :service do
  subject { LinkChecker.new }

  describe '#external_link?' do
    it { expect(subject.external_link?('/foo')).to be_falsey }
    it { expect(subject.external_link?('foo')).to be_falsey }
    it { expect(subject.external_link?('/foo/bar')).to be_falsey }
    it { expect(subject.external_link?('http://example.com')).to be_truthy }
    it { expect(subject.external_link?('http://example.com/foo')).to be_truthy }
    it { expect(subject.external_link?('http://example.com/foo/bar')).to be_truthy }
    it { expect(subject.external_link?('https://example.com')).to be_truthy }
    it { expect(subject.external_link?('https://example.com/foo')).to be_truthy }
    it { expect(subject.external_link?('https://example.com/foo/bar')).to be_truthy }
    it { expect(subject.external_link?('//example.com/foo/bar')).to be_truthy }
    if !ENV['APP_DOMAIN'].blank?
      it { expect(subject.external_link?(ENV['APP_DOMAIN'] + '/foo')).to be_falsey }
    end
  end

  describe '#valid_link?' do

    let!(:root_node) { Fabricate(:root_node) }
    let!(:section) { Fabricate(:section, name: 'section') }
    let!(:section_home) { Fabricate(:section_home, section: section) }

    context 'invalid links' do
      it { expect(subject.valid_internal_link?('foo')).to be_falsey }
      it { expect(subject.valid_internal_link?('foo/bar')).to be_falsey }
    end
    context 'valid links' do
      it { expect(subject.valid_internal_link?('/')).to be_truthy }
    end

    describe 'general content' do

      let(:general_content) { Fabricate(:general_content, parent: section_home) }
      context 'invalid node link' do
        it { expect(subject.valid_internal_link?(section.slug + '/news/' + general_content.slug)).to be_falsey }
      end

      context 'valid node link' do

        it { expect(subject.valid_internal_link?(section.slug)).to be_truthy }
        it { expect(subject.valid_internal_link?(section.slug + '/' + general_content.slug)).to be_truthy }
      end
    end

    describe 'news article' do

      context 'valid published' do
        let!(:published) { Fabricate(:news_article, section: section, state: 'published') }
        it { expect(subject.valid_internal_link?('/' + section.slug + '/news/' + published.slug)).to be_truthy }
      end

      context 'valid draft' do
        let!(:draft) { Fabricate(:news_article, section: section, state: 'draft') }
        it { expect(subject.valid_internal_link?(section.slug + '/news/' + draft.slug)).to be_falsey }
      end
    end

  end

  # describe '#my_render_string' do
  #   context 'with valid links' do
  #       valid_links = '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
  # <html>
  # <head>
  # <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  # </head>
  # <body>
  # <h1>Hello</h1>
  # <p>Here is a <a href="/users/sign_in">good link</a></p>
  # <p>Here is a <a href="/editorial/">good link</a></p>
  # <p>Here is a <a href="/editorial">good link</a></p>
  # <p>Here is a <a href="editorial">good link</a></p>
  # <p>Here is a <a href="editorial/">good link</a></p>
  # <p>Here is an <a href="http://example.com">external link</a></p>
  # <p>Here is an <a href="https://example.com/editorial">external link</a></p>
  # <p>Here is an <a href="http://example.com/editorial/">external link</a></p>
  # </body>
  # </html>
  # '
  # it "unchanged" do
  # expect(subject.my_render_string(valid_links)).to eq(valid_links)
  # end

  # it { expect(subject.my_render_string(valid_links)).to have_css('h1') }
  #   end
  # end


end
