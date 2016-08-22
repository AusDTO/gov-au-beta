require 'rails_helper'

RSpec.describe InviteAccepter, type: :service do
  describe '#accept_invitation!' do
    let(:invite) { Fabricate(:invite) }
    subject { described_class.new(invite).perform! }

    it 'returns token' do
      expect(subject).not_to be_empty
    end

    context 'when previously accepted' do
      before do
        invite.accepted_token = 'tokentoken'
      end
      it 'raises exception' do
        expect{ subject }.to raise_error
      end
    end
  end
end
