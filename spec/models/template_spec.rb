require 'rails_helper'

RSpec.describe Template, type: :model do
  it { should validate_uniqueness_of(:name).case_insensitive }
end
