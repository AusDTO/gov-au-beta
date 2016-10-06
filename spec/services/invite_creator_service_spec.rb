require 'rails_helper'

RSpec.describe InviteCreator, type: :service do
  describe '#perform' do
    subject { described_class.new('foo@example.gov.au') }

    it { expect { subject.perform! }.to change(Invite, :count).by(1) }

    it 'sets invite code' do
      expect(subject.perform!.code).not_to be_empty
    end
  end
end
