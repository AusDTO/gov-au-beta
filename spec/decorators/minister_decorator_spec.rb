require 'rails_helper'

RSpec.describe MinisterDecorator, type: :decorator do
  let(:pm) { Fabricate(:minister, name: 'Prime Minister').decorate }
  let(:comms) { Fabricate(:minister, name: 'Minister for Communications').decorate }
  let(:arts) { Fabricate(:minister, name: 'Minister for the Arts').decorate }

  context 'Prime Minister' do
    subject { pm }
    it { expect(subject.prefix).to be_nil }
    it { expect(subject.ministry_or_title).to eq 'Prime Minister' }
  end

  context 'Minister for Communications' do
    subject { comms }
    it { expect(subject.prefix).to eq 'Minister for' }
    it { expect(subject.ministry_or_title).to eq 'Communications' }
  end

  context 'Minister for the Arts' do
    subject { arts }
    it { expect(subject.prefix).to eq 'Minister for the' }
    it { expect(subject.ministry_or_title).to eq 'Arts' }
  end

  describe '#sort_order' do
    subject { [arts, comms, pm].sort_by {|minister| minister.sort_order } }

    it { is_expected.to eq [pm, arts, comms] }
  end
end
