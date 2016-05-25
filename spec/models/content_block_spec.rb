require 'rails_helper'

RSpec.describe ContentBlock, type: :model do
  it { is_expected.to belong_to :node }
end
