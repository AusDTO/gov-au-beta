require 'rails_helper'

RSpec.describe Section, type: :model do

  it { is_expected.to have_many :nodes }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }
  
end
