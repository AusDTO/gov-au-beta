require "rails_helper"

def message_part(mail, content_type)
  mail.body.parts.find { |part| part.content_type.match content_type }.body.raw_source
end

# Requires locals: mail
RSpec.shared_examples 'a multipart email' do
  it 'with parts' do
    expect(mail.body).to be_multipart
  end
  it 'with two parts' do
    expect(mail.body.parts.count).to eq(2)
  end
  it 'with plain text first' do
    expect(mail.body.parts.first['Content-Type'].value).to eq('text/plain')
  end
  it 'with html second' do
    expect(mail.body.parts.second['Content-Type'].value).to eq('text/html')
  end
end

# Requires locals: mail, content
RSpec.shared_examples 'has content' do
  it "in plain text part" do
    expect(message_part(mail, /plain/)).to match(content)
  end
  it "in html part" do
    expect(message_part(mail, /html/)).to match(content)
  end
end

RSpec.describe Notifier, type: :mailer do

  describe '#author_request' do
    let(:section) { Fabricate(:topic) }
    let!(:requester) { Fabricate(:user) }
    let!(:owner) { Fabricate(:user, owner_of: section) }
    let(:request) { Fabricate(:request, section: section, user: requester) }
    let(:mail) { described_class.author_request(request).deliver_now }

    it_behaves_like 'a multipart email'

    it 'sends to topic owners' do
      expect(mail.to).to eq(User.with_role(:owner, section).pluck(:email))
    end

    it_behaves_like 'has content' do
      let!(:content) { editorial_section_request_path(section, request) }
    end
    it_behaves_like 'has content' do
      let!(:content) { requester.email }
    end
  end

  describe '#user_invite' do
    let(:user) { Fabricate(:user) }
    let(:reset_token) { 'reset_token' }
    let(:mail) { described_class.user_invite(user, reset_token).deliver_now }

    it_behaves_like 'a multipart email'

    it 'sends to the user' do
      expect(mail.to).to eq([user.email])
    end

    it_behaves_like 'has content' do
      let!(:content) { reset_token }
    end
  end
end
