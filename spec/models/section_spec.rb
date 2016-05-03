require 'rails_helper'

RSpec.describe Section, type: :model do

  it { should have_many :nodes }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_uniqueness_of(:slug).case_insensitive }
  
end
