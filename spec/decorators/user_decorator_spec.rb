require 'rails_helper'

RSpec.describe UserDecorator, type: :decorator do
  describe '#pending_request_for' do
    let(:user)    { Fabricate(:user) }
    let(:section) { Fabricate(:section) }
    subject       { described_class.new(user).pending_request_for(section) }

    context 'no pending requests' do
      it { is_expected.to be(nil) }
    end

    context 'with a pending request for the section' do
      let!(:request) { Request.create!(section: section, user: user, state: 'requested') }
      it { is_expected.to eq(request) }
    end
  end
end
