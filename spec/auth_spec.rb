require 'spec_helper'

describe Traxo::Auth do
  let(:auth) { Traxo::Auth.new('TEST_ID', 'TEST_SECRET') }
  let(:oauth_address) { "https://www.traxo.com/oauth/" }
  let(:token_address) { "#{oauth_address}token/"}

  it 'holds the Traxo OAuth address as a constant' do
    expect(Traxo::Auth::OAUTH_URL).to eq oauth_address
  end

  it 'holds the Traxo token exchange address as a constant' do
    expect(Traxo::Auth::TOKEN_URL).to eq token_address
  end

  describe '#request_code_url' do
    let(:url) { auth.request_code_url('wilchandler.me') }

    it 'returns a url string' do
      expect(url).to match oauth_address
    end

    it 'contains the client_id' do
      expect(url).to match(/client_id=TEST_ID/)
    end

    it 'contains the response_type' do
      expect(url).to match(/response_type=code/)
    end

    it 'contains the direct_uri' do
      expect(url).to match(/redirect_uri=wilchandler.me/)
    end

    it 'contains the default state if not specified' do
      expect(url).to match(/state=live/)
    end

    it 'contains the specified state if provided' do
      specified = auth.request_code_url('wilchandler.me', 'a_test_state')
      expect(specified).to match(/state=a_test_state/)
    end
  end

end
