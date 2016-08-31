require 'rails_helper'

class AusPhoneNumberValidatable
  include ActiveModel::Validations
  attr_accessor :number
  validates :number, aus_phone_number: true

  def initialize(number)
    @number = number
  end
end

describe AusPhoneNumberValidator do
  let(:valid_aus_phone_num) {
    AusPhoneNumberValidatable.new '0423456789'
  }

  let(:num_too_short) {
    AusPhoneNumberValidatable.new '04145678'
  }

  let(:num_too_long) {
    AusPhoneNumberValidatable.new '042345678912'
  }

  let(:num_starts_wrong) {
    AusPhoneNumberValidatable.new '0912345654'
  }


  context 'valid number' do
    subject { valid_aus_phone_num }

    it { is_expected.to be_valid }
  end


  context 'number too short 'do
    subject { num_too_short }

    it { is_expected.to_not be_valid }
  end


  context 'number too long' do
    subject { num_too_long }

    it { is_expected.to_not be_valid }
  end


  context 'number starts incorrectly' do
    subject { num_starts_wrong }

    it { is_expected.to_not be_valid }
  end
end