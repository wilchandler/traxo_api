require 'spec_helper'

describe 'Traxo::Client air segments endpoints' do
  let(:client) { Traxo::Client.new('TEST_TOKEN', '', '') }
  let(:headers) { {'Authorization' => 'Bearer TEST_TOKEN'} }
  let(:address_base) { "#{ Traxo::Client::API_URL}segments/air" }
  let(:id) { 123456 }
  let(:address_id) { "#{address_base}/#{id}" }
  let(:single_fixture) { File.new("#{FIXTURES_DIR}/client/segments/air_segment.json") }
  let(:collection_fixture) { File.new("#{FIXTURES_DIR}/client/segments/air_segments.json") }

  describe '#get_air_segments' do
    pending
  end

  describe '#get_air_segment' do
    pending
  end

  describe '#create_air_segment' do
    pending
  end

  describe '#update_air_segment' do
    pending
  end

  describe '#delete_air_segment' do
    pending
  end
end
