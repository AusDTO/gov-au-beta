require 'rails_helper'

RSpec.describe Section, type: :model do
  let!(:root_node) { Fabricate(:root_node) }

  it { is_expected.to have_many :nodes }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

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
  end
end
