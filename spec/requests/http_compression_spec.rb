require 'rails_helper'

RSpec.describe 'HTTP Compression', type: :request do
  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let!(:real_category) { Fabricate(:category) }

  context 'when no Accept-Encoding request header is set' do
    before { get '/' }

    it 'does not set the Content-Encoding response header' do
      expect(response.headers).to_not have_key('Content-Encoding')
    end
  end

  context 'when Accept-Encoding request header is set to "gzip, deflate"' do
    before do
      get '/', headers: { 'HTTP_ACCEPT_ENCODING' => 'gzip, deflate' }
    end

    it 'sets the Content-Encoding response header to "gzip"' do
      expect(response.headers).to have_key('Content-Encoding')
    end
  end
end
