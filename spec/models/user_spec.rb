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
end
