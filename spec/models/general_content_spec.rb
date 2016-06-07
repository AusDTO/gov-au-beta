require 'rails_helper'

RSpec.describe GeneralContent, type: :model do
  it { expect(described_class).to be < Node }
end
