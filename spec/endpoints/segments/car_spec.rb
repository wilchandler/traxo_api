require 'spec_helper'

describe 'Traxo::Client car segments endpoints' do
  let(:client) { Traxo::Client.new('TEST_TOKEN', '', '') }
  let(:headers) { {'Authorization' => 'Bearer TEST_TOKEN'} }
  let(:base_address) { "#{ Traxo::Client::API_URL}segments/car" }
  let(:id) { 123456 }
  let(:id_address) { "#{base_address}/#{id}" }
  let(:single_fixture) { File.new("#{FIXTURES_DIR}/client/segments/car_segment.json") }
  let(:collection_fixture) { File.new("#{FIXTURES_DIR}/client/segments/car_segments.json") }

  describe '#get_car_segments' do
    let(:args) { { status: 'Deleted', start: Date.today, end: Date.today.next_month } }
    let(:call) { client.get_car_segments(args) }
    let(:stub) do 
      stub_request(:get, base_address).with(headers: headers, query: args)
                                      .to_return(status: 200, body: collection_fixture)
      end

    it 'sends an appropriate GET request' do
      stub && call

      expect(stub).to have_been_requested
    end
  end

  describe '#get_car_segment' do
    let(:stub) do
      stub_request(:get, id_address).with(headers: headers)
                                    .to_return(status: 200, body: single_fixture)
    end
    let(:call) { client.get_car_segment(id) }

    it 'sends an appropriate GET request' do
      stub && call

      expect(stub).to have_been_requested
    end
  end

  describe '#create_car_segments' do
    let(:p_time) { Time.now }
    let(:d_time) { p_time + 60 * 60 * 24 }
    let(:args) do
      {
        trip_id: id.to_s,
        car_company: 'Avis',
        pickup_datetime: p_time,
        dropoff_datetime: d_time,
        pickup_city: 'Little Rock, AR',
        dropoff_city: 'Nashville, TN',
        pickup_address1: '1200 President Clinton Ave',
        pickup_address2: 'Level 1',
        pickup_zip: '72201',
        dropoff_address1: '2804 Opryland Dr',
        dropoff_address2: 'Level 1',
        dropoff_zip: 37214.to_s,
        confirmation_no: 123456.to_s,
        price: 300.to_s,
        currency: 'USD',
        phone: '(501)374-4242',
        first_name: 'William',
        last_name: 'Clinton'
      }
    end
    let(:string_time_args) { args.merge({ pickup_datetime: p_time.iso8601, dropoff_datetime: d_time.iso8601})}
    let(:call) { client.create_car_segment(args) }
    let(:stub) do
      stub_request(:post, base_address).with(headers: headers, body: string_time_args)
                                       .to_return(status: 201, body: single_fixture)
    end

    it 'sends an appropriate POST request' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'raises an error if a required argument key is not present' do
      required = [:trip_id, :car_company, :pickup_datetime, :dropoff_datetime,
                  :pickup_city, :dropoff_city]
      required.each do |arg|
        bad_args = args.dup
        bad_args.delete(arg)
        expect{ client.create_car_segment(bad_args) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#update_car_segments' do
    pending
  end

  describe '#delete_car_segments' do
    let(:stub) do
      stub_request(:delete, id_address).with(headers: headers)
                                       .to_return(status: 200, body: '')
    end
    let(:call) { client.delete_car_segment(id) }

    it 'sends an appropriate DELETE request' do
      stub && call

      expect(stub).to have_been_requested
    end
  end
end