require 'spec_helper'

describe 'Traxo::Client member endpoints' do
  let(:client) { Traxo::Client.new('TEST_TOKEN', 'TEST_ID', 'TEST_SECRET') }
  let(:headers) { { 'Authorization' => 'Bearer TEST_TOKEN' } }

  describe '#get_member' do
    let(:address) { "#{Traxo::Client::API_URL}me" }
    let(:call) { client.get_member }
    let(:stub) do
      stub_request(:get, address)
      .with(headers: headers)
      .to_return(body: File.new("#{FIXTURES_DIR}/client/member/member.json"))
    end

    before(:each) { stub }

    it 'makes a GET request with an access token in the headers' do
      call

      expect(stub).to have_been_requested
    end

    # xit 'returns a Member object' do
    #   result = call

    #   expect(result).to be_instance_of Traxo::Member
    # end
  end

  describe '#get_stream' do
    let(:address) { "#{Traxo::Client::API_URL}stream" }
    let(:response_fixture) { File.new "#{FIXTURES_DIR}/client/member/stream.json" }
    let(:stub) do
      stub_request(:get, address)
      .with(headers: headers)
      .to_return(body: response_fixture)
    end
    let(:call) { client.get_stream }

    before(:each) { stub }

    it 'makes a GET request with an access token in the headers' do
      call

      expect(stub).to have_been_requested
    end

    # THIS WILL PROBABLY CHANGE!
    it 'returns parsed JSON (an Array, in this case)' do
      result = call

      expect(result).to be_instance_of Array
    end

    it 'accepts an offset parameter' do
      stub_query = { 'offset' => '1' }
      offset_stub = stub_request(:get, address)
                    .with(headers: headers, query: stub_query)
                    .to_return(body: '[]')
      client.get_stream(offset: 1)

      expect(offset_stub).to have_been_requested
    end

    it 'accepts a limit parameter' do
      stub_query = { 'limit' => '2' }
      limit_stub = stub_request(:get, address)
                    .with(headers: headers, query: stub_query)
                    .to_return(body: '[]')
      client.get_stream(limit: 2)

      expect(limit_stub).to have_been_requested
    end

    it 'can combine parameters' do
      query = { 'limit' => '2', offset: '5' }
      two_param_stub = stub_request(:get, address)
                    .with(headers: headers, query: query)
                    .to_return(body: '[]')
      client.get_stream(limit: 2, offset: 5)

      expect(two_param_stub).to have_been_requested
    end

    # xit 'accepts a count parameter (to be returned via X-Total-Count header' do
    # end
  end

end
