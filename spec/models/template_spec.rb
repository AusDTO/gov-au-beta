require 'rails_helper'

RSpec.describe Template, type: :model do
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_uniqueness_of(:slug).case_insensitive }
end
