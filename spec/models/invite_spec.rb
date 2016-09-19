require 'rails_helper'

RSpec.describe Invite, type: :model do
  it { is_expected.to validate_presence_of :email }

  subject { Fabricate(:invite) }

  context 'when email is valid' do
    it { is_expected.to be_valid }
  end

  context 'when email is invalid' do
    before { subject.email= 'foo' }
    it { is_expected.to be_invalid }
  end

  context 'when accepted_token is not present' do
    it { expect(subject.accepted?).to be_falsey}
  end

  context 'when accepted_token is present' do
    before {subject.accepted_token = 'tokentoken' }
    it { expect(subject.accepted?).to be_truthy }
  end
end
