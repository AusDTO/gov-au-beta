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


  describe 'send_two_factor_authentication_code' do
    let!(:user) { Fabricate(:user, bypass_tfa: false, phone_number: '0423456789',
                            direct_otp: '123456', account_verified: true)
    }

    let!(:send_sms_request) {
      stub_request(:post, "https://smsapi.com:80/send").
          with(:body => "{\"to\":\"#{user.phone_number}\",\"body\":\"Your GOV.AU two-factor authentication code is #{user.direct_otp}\"}",
               :headers => {'Authorization'=>'Bearer somereallyspecialtoken', 'Content-Type'=>'application/json'}).
          to_return(:status => 200, :body => "", :headers => {})
    }

    let!(:valid_authenticate_request) {
      stub_request(:post, Rails.configuration.sms_authenticate_url).
          with(:body => {"client_id"=>"", "client_secret"=>"", "grant_type"=>"client_credentials", "scope"=>"SMS"},
               :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
          to_return(:status => 200, :body => '{"access_token":"somereallyspecialtoken", "expires_in":"3599"}', :headers => {})
    }

    context 'for a configured user signing in' do
      subject {
        user.send_two_factor_authentication_code(user.direct_otp)
      }


      it { expect{ subject }.to_not raise_error }
    end
  end
end
