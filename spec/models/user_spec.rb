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

  describe "email validations" do
    it "only allows *.gov.au emails" do
      user = User.new(email: "alice@not-allowed.com")
      expect(user.errors_on(:email)).to eql(["only *.gov.au email addresses permitted"])
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


  describe 'one time passwords' do
    let!(:user) {
      Fabricate(:user, bypass_tfa: false, confirmed_at: Time.now.utc,
                phone_number: '0423456789', account_verified: true,
                identity_verified_at: Time.now.utc)
    }


    before {
      user.unconfirmed_phone_number = '0433333333'
      user.create_direct_otp_for(:unconfirmed_phone_number_otp)
    }

  end
end
