require 'spec_helper'

describe Traxo::Client do
  let(:client) { Traxo::Client.new('TEST_CLIENT_ID', 'TEST_CLIENT_SECRET', 'TEST_ACCESS_TOKEN') }

  it 'holds the correct API address as a constant' do
    url = "https://api.traxo.com/v2/"
    expect(Traxo::Client::API_URL).to match url
  end

  it 'allows writing to the access_token (makes refreshing tokens easier)' do
    expect{ client.access_token = 'NEW_ACCESS_TOKEN' }.to change{ client.access_token }
  end

  describe '#return_body!' do
    it 'updates the response_format to :body' do
      client.return_code! # :body is the default, must be changeable for test

      expect{ client.return_body! }.to change{ client.response_format }.to(:body)
    end

    it 'is the default behavior' do
      expect{ client.return_body! }.not_to change{ client.response_format }
    end
  end

  describe '#return_body_string!' do
    it 'updates the response_format to :body_string' do
      expect{ client.return_body_string! }.to change{ client.response_format }.to(:body_string)
    end
  end

  describe '#return_headers!' do
    it 'updates the response_format to :headers' do
      expect{ client.return_headers! }.to change{ client.response_format }.to(:headers)
    end
  end

  describe '#return_headers_string!' do
    it 'updates the response_format to :headers_string' do
      expect{ client.return_headers_string! }.to change{ client.response_format }.to(:headers_string)
    end
  end

  describe '#return_code!' do
    it 'updates the response_format to :code' do
      expect{ client.return_code! }.to change{ client.response_format }.to(:code)
    end
  end

  describe '#return_http_object!' do
    it 'updates the response_format to :http' do
      expect{ client.return_http_object! }.to change{ client.response_format }.to(:http)
    end
  end

  describe 'formatting of responses' do
    let(:call) { client.get_trip(123456) }
    let(:fixture) { File.new("#{FIXTURES_DIR}/client/trips/trip.json") }
    let(:stub) do
      stub_request(:any, /./).to_return(status: 200, body: fixture, :headers => { 'Content-Length' => 3 })
    end

    before(:each) { stub }

    context '@response_format is :body' do
      it 'returns a Net::HTTPResponse object' do
        client.return_body!
        result = call

        expect(result).to be_instance_of Hash
      end
    end

    context '@response_format is :body_string' do
      it 'returns a Net::HTTPResponse object' do
        client.return_body_string!
        result = call

        expect(result).to be_instance_of String
      end
    end

    context '@response_format is :headers' do
      it 'returns a Net::HTTPResponse object' do
        client.return_headers!
        result = call

        expect(result).to be_instance_of Hash
      end
    end

    context '@response_format is :headers' do
      it 'returns a Net::HTTPResponse object' do
        client.return_headers_string!
        result = call

        expect(result).to be_instance_of String
      end
    end

    context '@response_format is :code' do
      it 'returns a Net::HTTPResponse object' do
        client.return_code!
        result = call

        expect(result).to be_instance_of Fixnum
      end
    end

    context '@response_format is :http' do
      it 'returns a Net::HTTPResponse object' do
        client.return_http_object!
        result = call

        expect(result.is_a? Net::HTTPResponse).to be true
      end
    end
  end

  describe '#ignore_http_errors!' do
    it 'updates @raise_http_errors to be false' do
      expect{ client.ignore_http_errors! }.to change{ client.raise_http_errors }.to(false)
    end
  end

  describe '#raise_http_errors!' do
    it 'updates @raise_http_errors to be true' do
      client.ignore_http_errors! # raises by default

      expect{ client.raise_http_errors! }.to change{ client.raise_http_errors }.to(true)
    end

    it 'is the default behavior for a client object' do
      expect{ client.raise_http_errors! }.not_to change{ client.raise_http_errors }
    end
  end

  describe 'handling HTTP errors' do
    let(:call) { client.get_trip(123456) }
    # let(:fixture) { File.new("#{FIXTURES_DIR}/client/trips/trip.json") }
    let(:stub) do
      stub_request(:any, /./).to_return(status: 404, body: '{}', :headers => { 'Content-Length' => 3 })
    end

    before(:each) { stub }

    context '@raise_http_errors is true (default)' do
      it 'raises an error when the status code is not 2xx' do
        expect{ call }.to raise_error
      end
    end

    context '@raise_http_errors is false' do
      it 'returns false whent the status code is not 2xx' do
        client = Traxo::Client.new('TEST_CLIENT_ID', 'TEST_CLIENT_SECRET', 'TEST_ACCESS_TOKEN', errors: :ignore)
        result = client.get_trip(123456) 

        expect(result).to be false
      end
    end
  end

end