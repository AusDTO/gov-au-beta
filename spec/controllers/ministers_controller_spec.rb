require 'rails_helper'

RSpec.describe MinistersController, type: :controller do
  describe 'GET #index' do
    let!(:health) { Fabricate(:minister, name: 'Minister for Health') }
    let!(:pm) { Fabricate(:minister, name: 'Prime Minister') }
    let!(:comms) { Fabricate(:minister, name: 'Minister for Communications') }

    before { get :index }

    it { expect(response.status).to eq(200) }
    it { expect(subject.ministers).to eq [pm, comms, health] }
  end
end
