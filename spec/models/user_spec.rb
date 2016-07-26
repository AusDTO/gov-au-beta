require 'rails_helper'

RSpec.describe User, type: :model do
  describe "password validations" do
    it "always requires a password for a new user" do
      unpersisted_user = User.new
      expect(unpersisted_user.valid?).to be(false)
      expect(unpersisted_user).to have(1).error_on(:password)
    end

    it "does not require a password for a peristed user" do
      persisted_user = Fabricate(:user)
      expect(persisted_user.valid?).to be(true)
    end
  end

  describe 'section membership' do
    let!(:section_a) { Fabricate(:section) }
    let!(:section_b) { Fabricate(:section) }
    let!(:section_c) { Fabricate(:section) }

    let!(:user) { Fabricate(:user) }
    let!(:author) { Fabricate(:user, author_of: section_a) }
    let!(:reviewer) { Fabricate(:user, reviewer_of: section_b, author_of: section_a) }
    let!(:admin) { Fabricate(:user, is_admin: true) }

    context 'as a user with no membership' do
      it 'should have no membership' do
        expect(user.member_of_sections).to eq([])
      end
    end

    context 'as an author of a single section' do
      it 'should have a single membership' do
        expect(author.member_of_sections).to eq([section_a])
      end
    end

    context 'as a reviewer and author' do
      it 'should have two memberships' do
        expect(reviewer.member_of_sections).to include(section_a, section_b)
      end
    end

    context 'as an admin' do
      it 'should have all memberships' do
        expect(admin.member_of_sections).to eq(Section.where.not(name: 'news'))
      end
    end
  end
end
