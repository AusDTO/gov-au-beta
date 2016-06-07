require 'rails_helper'

RSpec.describe NewsArticle, type: :model do
  it { expect(described_class).to be < Node }
  it { is_expected.to respond_to :release_date }
end
