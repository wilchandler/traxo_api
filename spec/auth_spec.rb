require 'spec_helper'

describe Traxo::Auth do
  let(:auth) { Traxo::Auth.new('TEST_ID', 'TEST_SECRET') }
  let(:oauth_address) { "https://www.traxo.com/oauth/" }
  let(:token_address) { "#{oauth_address}token/"}
  let(:redirect_uri) { "wilchandler.me" }

  it 'holds the Traxo OAuth address as a constant' do
    expect(Traxo::Auth::OAUTH_URL).to eq oauth_address
  end

  it 'holds the Traxo token exchange address as a constant' do
    expect(Traxo::Auth::TOKEN_URL).to eq token_address
  end

  describe '#request_code_url' do
    let(:url) { auth.request_code_url(redirect_uri) }

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
      expect(url).to match(/redirect_uri=#{redirect_uri}/)
    end

    it 'contains the default state if not specified' do
      expect(url).to match(/state=live/)
    end

    it 'contains the specified state if provided' do
      specified = auth.request_code_url(redirect_uri, 'a_test_state')
      expect(specified).to match(/state=a_test_state/)
    end
  end

  describe '#exchange_request_code' do
    let(:call) { auth.exchange_request_code('TEST_CODE', redirect_uri) }
    let(:response_fixture) { File.new("#{FIXTURES_DIR}/auth/exchange_request_code.json", 'r') }
    let(:stub) { stub_request(:post, token_address).to_return(body: response_fixture) }

    before(:each) { stub }

    it 'makes a POST request to the Traxo token address' do
      call
      expect(stub).to have_been_requested
    end

    it 'returns a Hash (parsed from JSON)' do
      response = call
      expect(response).to be_instance_of Hash
    end

    it 'sends necessary data' do
      data = {
        client_id: 'TEST_ID',
        client_secret: 'TEST_SECRET',
        grant_type: 'authorization_code',
        redirect_uri: redirect_uri,
        code: 'TEST_CODE'
      }

      data_specific_stub = stub_request(:post, token_address)
                           .with(body: data)
                           .to_return(body: File.new("#{FIXTURES_DIR}/auth/exchange_request_code.json", 'r'))

      call
      expect(data_specific_stub).to have_been_requested 
    end

  end

end
