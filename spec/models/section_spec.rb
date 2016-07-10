require 'rails_helper'

RSpec.describe Section, type: :model do

  it { is_expected.to have_many :nodes }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }

  describe '#users' do
    context 'section with no users' do
      let!(:section) { Fabricate(:section) }
      it 'returns no users' do
        expect(section.users).to eq []
      end
    end

    context 'section with an author user' do
      let!(:section) { Fabricate(:section) }
      let!(:author) { Fabricate(:user, author_of: section) }
      let!(:other_section) { Fabricate(:section) }
      let!(:other_author) { Fabricate(:user, author_of: other_section) }
      it 'returns author user' do
        expect(section.users).to eq [author]
      end
    end

    context 'find node' do
      let(:section) { Fabricate(:section) }
      let!(:published) { Fabricate(:node, name: 'blah', state: 'published', section: section) }
      let!(:draft)     { Fabricate(:node, name: 'vtha', state: 'draft', section: section) }

      it 'finds a published node based on path' do
        expect(section.find_node!('blah')).to eq(published)
      end

      it 'cannot find an unpublished node' do
        expect{ section.find_node!('vtha') }.to raise_error ActiveRecord::RecordNotFound
      end

    end
  end
end
