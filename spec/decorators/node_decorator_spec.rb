require 'rails_helper'

RSpec.describe NodeDecorator, type: :decorator do
  describe '#template' do
    context 'for general content' do
      let(:node) { Fabricate(:general_content) }
      subject { described_class.new(node).template }

      it { is_expected.to eq('general_content') }
    end

    context 'for a news article' do
      let(:node) { Fabricate(:news_article) }
      subject { described_class.new(node).template }

      it { is_expected.to eq('news_article') }
    end
  end

  describe '#rendered' do
    let(:node) { Fabricate(:general_content).decorate }
    it 'caches the results' do
      expect(node.rendered).to be(node.rendered)
    end
  end
end
