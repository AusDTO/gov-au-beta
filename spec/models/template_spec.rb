require 'rails_helper'

RSpec.describe Template, type: :model do
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
