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
    let(:d_time) { Time.now }
    let(:a_time) { d_time + 60 * 60 * 2}
    let(:args) do
      {
        trip_id: id.to_s,
        origin: 'ORD',
        destination: 'LIT',
        departure_datetime: d_time,
        arrival_datetime: a_time,
        airline: 'AA',
        flight_num: 321.to_s,
        seat_assignment: '3A',
        confirmation_no: '123456789',
        number_of_pax: 6.to_s,
        price: 300.to_s,
        currency: 'USD',
        phone: '555-555-5555',
        first_name: 'Wil',
        last_name: 'Chandler'
      }
    end
    let(:string_time_args) { args.merge({ departure_datetime: d_time.iso8601, arrival_datetime: a_time.iso8601 }) }
    let(:call) {  client.create_air_segment(args) }
    let(:stub) do
      stub_request(:post, base_address).with(headers: headers, body: string_time_args)
                                       .to_return(status: 201, body: single_fixture)
    end

    it 'sends an appropriate POST request' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'raises an error if a required argument key is not present' do
      required = [:trip_id, :origin, :destination, :departure_datetime,
                  :arrival_datetime, :airline, :flight_num]
      required.each do |arg|
        bad_args = args.dup
        bad_args.delete(arg)
        expect{ client.create_air_segment(bad_args) }.to raise_error(ArgumentError)
      end

    end
  end

  describe '#update_air_segment' do
    let(:d_time) { Time.now }
    let(:a_time) { d_time + 60 * 60 * 2}
    let(:args) do
      {
        trip_id: 12345.to_s,
        origin: 'ORD',
        destination: 'LIT',
        departure_datetime: d_time,
        arrival_datetime: a_time,
        airline: 'AA',
        flight_num: 321.to_s,
        seat_assignment: '3A',
        confirmation_no: '123456789',
        number_of_pax: 6.to_s,
        price: 300.to_s,
        currency: 'USD',
        phone: '555-555-5555',
        first_name: 'Wil',
        last_name: 'Chandler'
      }
    end
    let(:call) { client.update_air_segment(id, args) }
    let(:string_time_args) { args.merge({ departure_datetime: d_time.iso8601, arrival_datetime: a_time .iso8601 }) }
    let(:stub) do 
      stub_request(:put, id_address).with(headers: headers, body: string_time_args)
                                    .to_return(status: 200, body: single_fixture)
    end

    it 'sends an appropriate PUT request' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'raises an error if no valid keys are present in \'args\' hash' do
      bad_args = { :foo => :bar }

      expect{ client.update_air_segment(id, bad_args) }.to raise_error(ArgumentError)
    end
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
