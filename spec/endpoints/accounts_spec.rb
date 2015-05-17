require 'spec_helper'

describe 'Traxo::Client accounts endpoints' do
  let(:client) { Traxo::Client.new('', '', 'TEST_TOKEN') }
  let(:headers) { { 'Authorization' => 'Bearer TEST_TOKEN' } }

  describe '#get_account' do
    let(:id) { 1 }
    let(:address) { "#{Traxo::Client::API_URL}accounts/#{id}" }
    let(:call) { client.get_account(id) }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/accounts/account.json") }
    let(:stub) { stub_request(:get, address).with(headers: headers).to_return(body: fixture_response) }

    before(:each) { stub }

    it 'makes a GET request to the correct address with an address token in the headers' do
      call

      expect(stub).to have_been_requested
    end

    it 'returns a Traxo::Account object' do
      result = call

      expect(result).to be_instance_of Traxo::Account
    end
  end
end