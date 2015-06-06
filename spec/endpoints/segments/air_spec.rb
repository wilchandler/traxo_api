require 'spec_helper'

describe 'Traxo::Client air segments endpoints' do
  let(:client) { Traxo::Client.new('TEST_TOKEN', '', '') }
  let(:headers) { {'Authorization' => 'Bearer TEST_TOKEN'} }
  let(:base_address) { "#{ Traxo::Client::API_URL}segments/air" }
  let(:id) { 123456 }
  let(:id_address) { "#{base_address}/#{id}" }
  let(:single_fixture) { File.new("#{FIXTURES_DIR}/client/segments/air_segment.json") }
  let(:collection_fixture) { File.new("#{FIXTURES_DIR}/client/segments/air_segments.json") }

  describe '#get_air_segments' do
    let(:args) { { status: 'Deleted', start: Date.today, end: Date.today.next_month } }
    let(:call) { client.get_air_segments(args) }
    let(:stub) do
      stub_request(:get, base_address).with(headers: headers, query: args)
                                      .to_return(status: 200, body: collection_fixture)
    end

    it 'sends an appropriate GET request' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'defaults to \'today\' as the :start argument' do
      query = { start: 'today' }
      def_stub = stub_request(:get, base_address).with(headers: headers, query: query)
                                      .to_return(status: 200, body: collection_fixture)
      client.get_air_segments

      expect(def_stub).to have_been_requested
    end

  end

  describe '#get_air_segment' do
    let(:stub) do
      stub_request(:get, id_address).with(headers: headers)
                                    .to_return(status: 200, body: single_fixture)
    end
    let(:call) { client.get_air_segment(id) }

    it 'sends an appropriate GET request' do
      stub && call

      expect(stub).to have_been_requested
    end
  end

  describe '#create_air_segment' do
    pending
  end

  describe '#update_air_segment' do
    pending
  end

  describe '#delete_air_segment' do
    let(:stub) do
      stub_request(:delete, id_address).with(headers: headers)
                                       .to_return(status: 200, body: '')
    end
    let(:call) { client.delete_air_segment(id) }

    it 'sends an appropriate DELETE request' do
      stub && call

      expect(stub).to have_been_requested
    end
  end
end
