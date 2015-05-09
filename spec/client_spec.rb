require 'spec_helper'

describe Traxo::Client do

  it 'holds the correct API address as a constant' do
    url = "https://api.traxo.com/v2/"
    expect(Traxo::Client::API_URL).to match url
  end

  it 'allows writing to the access_token (makes refreshing tokens easier)' do
    client = Traxo::Client.new('TEST_CLIENT_ID', 'TEST_CLIENT_SECRET', 'TEST_ACCESS_TOKEN')
    expect{ client.access_token = 'NEW_ACCESS_TOKEN' }.to change{ client.access_token }
  end

end