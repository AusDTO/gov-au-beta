require 'rails_helper'

RSpec.describe Admin::MinistersController, type: :controller do

  describe '#find_resource' do

    let(:minister) { Fabricate(:minister) }

    subject { Admin::MinistersController.new.find_resource(minister.id) }

    it { is_expected.to eq(minister) }

  end

end
