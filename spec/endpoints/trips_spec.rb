require 'spec_helper'

describe 'Traxo::Client trips endpoints' do
  let(:client) { Traxo::Client.new('TEST_TOKEN', '', '') }
  let(:headers) { {'Authorization' => 'Bearer TEST_TOKEN'} }

  describe '#get_trips' do
    let(:call) { client.get_trips(start: nil) }
    let(:address) { "#{Traxo::Client::API_URL}trips"}
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trips.json") }
    let(:stub) do 
      stub_request(:get, address)
      .with(headers: headers)
      .to_return(body: fixture_response)
    end

    let(:options) do
      {
        segments: '1',
        start: 'yesterday',
        since: '2015-05-01',    # Filter results changed since this UTC date/time (ISO8601)
        :until => '2016-12-31', # Filter results changed until this UTC date/time (ISO8601)
        :end => 'tomorrow',
        recursive: '1',
        status: 'all',
        privacy: 'Public',
        purpose: 'Personal',
        offset: 3,
        limit: 4
      }
    end

    it 'makes a GET request to the corrrect address with an access token in the headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'includes a "start=today" parameter by default' do
      default_stub = stub_request(:get, address)
                     .with(headers: headers, query: {start: 'today'})
                     .to_return(body: fixture_response)
      client.get_trips

      expect(default_stub).to have_been_requested
    end

    it 'accepts a variety of parameters' do
      options_stub = stub_request(:get, address)
                     .with(headers: headers, query: options)
                     .to_return(body: fixture_response)
      client.get_trips(options)

      expect(options_stub).to have_been_requested
    end

    xit 'returns an array of Traxo::Trip objects' do
      stub
      response = call

      expect(response).to be_instance_of Array
      
      types = response.map(&:class).uniq
      expect(types).to eq [Traxo::Trip]
    end
  end

  describe '#get_trip' do
    let(:call) { client.get_trip(123456) }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trip.json") }
    let(:stub) do
      stub_request(:get, "#{Traxo::Client::API_URL}trips/123456")
      .with(headers: headers)
      .to_return(body: fixture_response)
    end
    
    it 'makes a GET request to the correct address (including trip id) with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'accepts a segments parameter' do
      segment_stub = stub_request(:get, "#{Traxo::Client::API_URL}trips/123456")
                     .with(headers: headers, query: {segments: 1})
                     .to_return(body: fixture_response)
      client.get_trip(123456, segments: true)

      expect(segment_stub).to have_been_requested
    end

    xit 'returns a Traxo::Trip object if found' do
      stub
      response = call

      expect(response).to be_instance_of Traxo::Trip
    end

    xit 'raises an exception if the trip is not found' do
    end
  end

  describe '#get_current_trip' do
    let(:address) { "#{Traxo::Client::API_URL}trips/current" }
    let(:call) { client.get_current_trip }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trip.json") }
    let(:stub) { stub_request(:get, address).with(headers: headers).to_return(body: fixture_response) }

    it 'makes a GET request to the correct address with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    xit 'returns a Traxo::Trip object if found' do
      stub
      response = call

      expect(response).to be_instance_of(Traxo::Trip)
    end

    xit 'raises an exception if not found' do
    end
  end

  describe '#get_upcoming_trips' do
    let(:address) { "#{Traxo::Client::API_URL}trips/upcoming" }
    let(:call) { client.get_upcoming_trips }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trips.json") }
    let(:stub) { stub_request(:get, address).with(headers: headers).to_return(body: fixture_response) }

    it 'makes a GET request to the correct address with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    xit 'returns an array of Traxo::Trip objects' do
      stub
      results = call
      types = results.map(&:class).uniq

      expect(results).to be_instance_of Array
      expect(types).to match_array [Traxo::Trip]
    end

    it 'accepts some options: segments, privacy, purpose, offset, limit' do
      args = { segments: 1, privacy: 'Buddies Only', purpose: 'Personal', offset: 5, limit: 10 }
      options_stub = stub_request(:get, address).with(headers: headers, query: args)
                                        .to_return(body: fixture_response)
      client.get_upcoming_trips(args)

      expect(options_stub).to have_been_requested      
    end
  end

  describe '#get_past_trips' do
    let(:address) { "#{Traxo::Client::API_URL}trips/past" }
    let(:call) { client.get_past_trips }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trips.json") }
    let(:stub) { stub_request(:get, address).with(headers: headers).to_return(body: fixture_response) }

    it 'makes a GET request to the correct address with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    xit 'returns an array of Traxo::Trip objects' do
      stub
      results = call
      types = results.map(&:class).uniq

      expect(results).to be_instance_of Array
      expect(types).to match_array [Traxo::Trip]
    end

    it 'accepts some options: segments, privacy, purpose, offset, limit' do
      args = { segments: 1, privacy: 'Buddies Only', purpose: 'Personal', offset: 5, limit: 10 }
      options_stub = stub_request(:get, address).with(headers: headers, query: args)
                                        .to_return(body: fixture_response)
      client.get_past_trips(args)

      expect(options_stub).to have_been_requested      
    end

  end

  describe '#get_trip_oembed' do
    let(:address) { "#{Traxo::Client::API_URL}trips/oembed/123456" }
    let(:call) { client.get_trip_oembed(123456) }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trip_oembed.json") }
    let(:stub) { stub_request(:get, address).with(headers: headers).to_return(body: fixture_response) }

    it 'makes a GET request to the correct address with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    xit 'returns a Traxo::TripOEmbed object if found' do
      stub
      response = call

      expect(response).to be_instance_of Traxo::TripOEmbed
    end

    xit 'raises an exception if not found' do
    end
  end

  describe '#create_trip' do
    it 'raises an error if its argument is not a Hash' do
      expect{ client.create_trip([]) }.to raise_error(ArgumentError)
    end

    context 'given a Hash of parameters' do

      it 'raises an exception if the required arguments are not provided' do
        args = { personal: true }

        expect{ client.create_trip(args) }.to raise_error(ArgumentError)
      end

      context 'given the required parameters' do
        let(:one_week) { Time.now + (60 * 60 * 24 * 7) }
        let(:two_weeks) { Time.now + (60 * 60 * 24 * 7) }
        let(:args) do
          {
            begin_datetime: one_week,
            end_datetime: two_weeks,
            destination: "Little Rock, AR"
          }
        end
        let(:args_with_string_dates) { args.merge({ begin_datetime: one_week.iso8601, end_datetime: two_weeks.iso8601 }) }
        let(:call) { client.create_trip(args) }
        let(:address) { 'https://api.traxo.com/v2/trips' }
        let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trip.json") }
        let(:stub) do
          stub_request(:post, address).with(body: args_with_string_dates, headers: headers)
                                      .to_return(body: fixture_response, status: 201)
        end

        xit 'returns a Traxo::Trip object if creation is successful' do
          stub
          result = call

          expect(result).to be_instance_of Traxo::Trip
        end

        it 'returns false if creation is unsuccessful' do
          stub_request(:post, address).with(body: args_with_string_dates, headers: headers)
                                      .to_return(status: 400)
          result = call

          expect(result).to be false
        end

        it 'makes a POST request to the correct addres with correct headers' do
          stub && call

          expect(stub).to have_been_requested
        end
      end
    end

    # context 'given a Traxo::Trip object as an argument' do

    #   xit 'updates and returns the provided object if creation is successful' do
    #   end

    #   xit 'returns false if creation is unsuccessful' do
    #   end

    #   xit 'stores errors in the provided object if creation is unsuccessful' do
    #   end

    # end

  end

  describe '#update_trip' do
    let(:id) { 123456 }
    let(:address) { "https://api.traxo.com/v2/trips/#{id}" }
    let(:args) {{ destination: 'Little Rock, AR', headline: 'Finally gonna tell her how I feel!' }}
    let(:call) { client.update_trip(id, args) }
    let(:fixture_response) { File.new("#{FIXTURES_DIR}/client/trips/trip.json") }
    let(:stub) do
      stub_request(:put, address).with(headers: headers, body: args)
                                 .to_return(status: 200, body: fixture_response)
    end

    it 'makes a PUT request to the correct address with correct headers and data' do
      stub && call

      expect(stub).to have_been_requested
    end

    xit 'returns a Traxo::Trip object if the update is successful' do
      stub
      result = call

      expect(result).to be_instance_of Traxo::Trip
    end

    it 'returns false if the update is unsuccessful' do
      stub_request(:put, address).with(headers: headers, body: args)
                                 .to_return(status: 403)
      result = call

      expect(result).to be false
    end
  end

  describe '#delete_trip' do
    let(:id) { 123456 }
    let(:address) { "https://api.traxo.com/v2/trips/#{id}" }
    let(:call) { client.delete_trip(id) }
    let(:stub) do
      stub_request(:delete, address).with(headers: headers)
                                    .to_return(status: 200)
    end

    it 'raises an exception if an ID integer is not provided' do
      expect{ client.delete_trip('foo') }.to raise_error(ArgumentError)
    end

    it 'makes a DELETE request to the correct address with correct headers' do
      stub && call

      expect(stub).to have_been_requested
    end

    it 'returns true if the deletion is successful' do
      stub
      result = call

      expect(result).to be true
    end

    it 'returns false if the deletion is unsuccessful' do
      stub_request(:delete, address).with(headers: headers)
                                    .to_return(status: 404)
      result = call

      expect(result).to be false
    end

  end

end
