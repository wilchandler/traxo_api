require 'spec_helper'

describe Traxo::Auth do
  let(:oauth_address) { "https://www.traxo.com/oauth/" }
  let(:auth) { Traxo::Auth.new('TEST_ID', 'TEST_SECRET', redirect_uri) }
  let(:token_address) { "#{oauth_address}token/"}
  let(:redirect_uri) { "wilchandler.me" }

  it 'holds the Traxo OAuth address as a constant' do
    expect(Traxo::Auth::OAUTH_URL).to eq oauth_address
  end

  it 'holds the Traxo token exchange address as a constant' do
    expect(Traxo::Auth::TOKEN_URL).to eq token_address
  end

  describe '#request_code_url' do
    let(:url) { auth.request_code_url('a_test_state') }

    it 'returns a url string' do
      expect(url).to match oauth_address
    end

    it 'contains the client_id' do
      expect(url).to match(/client_id=TEST_ID/)
    end

    it 'contains the response_type' do
      expect(url).to match(/response_type=code/)
    end

    it 'contains the redirect_uri' do
      expect(url).to match(/redirect_uri=#{redirect_uri}/)
    end

    it 'contains the specified state' do
      expect(url).to match(/state=a_test_state/)
    end

    it 'raises an ArgumentError if a (non-empty) String is provided for the state' do
      expect{ auth.request_code_url }.to raise_error(ArgumentError)
      expect{ auth.request_code_url('') }.to raise_error(ArgumentError)
      expect{ auth.request_code_url(1) }.to raise_error(ArgumentError)
    end
  end

  describe '#exchange_request_code' do
    let(:call) { auth.exchange_request_code('TEST_CODE') }
    let(:data) do
      {
        client_id: 'TEST_ID',
        client_secret: 'TEST_SECRET',
        grant_type: 'authorization_code',
        redirect_uri: redirect_uri,
        code: 'TEST_CODE'
      }
    end
    let(:response_fixture) { File.new("#{FIXTURES_DIR}/auth/exchange_request_code.json", 'r') }
    let(:stub) { stub_request(:post, token_address).with(body: data).to_return(body: response_fixture) }

    before(:each) { stub }

    it 'makes a POST request with correct data to the Traxo token address' do
      call
      expect(stub).to have_been_requested
    end

    it 'returns a Hash (parsed from JSON)' do
      response = call
      expect(response).to be_instance_of Hash
    end
  end


  describe '#exchange_refresh_token' do
    let(:call) { auth.exchange_refresh_token('TEST_REFRESH_TOKEN') }
    let(:data) do
      {
        client_id: 'TEST_ID',
        client_secret: 'TEST_SECRET',
        grant_type: 'refresh_token',
        refresh_token: 'TEST_REFRESH_TOKEN' 
      }
    end
    let(:response_fixture) { File.new("#{FIXTURES_DIR}/auth/exchange_refresh_token.json", 'r') }
    let(:stub) { stub_request(:post, token_address).with(body: data).to_return(body: response_fixture) }

    before(:each) { stub }
    
    it 'makes a POST request with the correct data to the Traxo token address' do
      call
      expect(stub).to have_been_requested
    end

    it 'returns a Hash (parsed from JSON)' do
      response = call
      expect(response).to be_instance_of Hash
    end
  end

end
