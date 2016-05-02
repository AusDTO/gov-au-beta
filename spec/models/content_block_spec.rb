require 'rails_helper'

RSpec.describe ContentBlock, type: :model do
  it { should belong_to :node }
end
