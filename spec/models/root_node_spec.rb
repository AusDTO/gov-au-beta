require 'rails_helper'

RSpec.describe RootNode, type: :model do

  it { is_expected.to validate_absence_of :slug }
  it { is_expected.to validate_absence_of :parent }

end
