require 'spec_helper'

describe 'Traxo::Client car segments endpoints' do
  let(:client) { Traxo::Client.new('TEST_TOKEN', '', '') }
  let(:headers) { {'Authorization' => 'Bearer TEST_TOKEN'} }
  let(:base_address) { "#{ Traxo::Client::API_URL}segments/car" }
  let(:id) { 123456 }
  let(:id_address) { "#{base_address}/#{id}" }
  # let(:single_fixture) { File.new("#{FIXTURES_DIR}/client/segments/car_segment.json") }
  # let(:collection_fixture) { File.new("#{FIXTURES_DIR}/client/segments/car_segments.json") }

  describe '#get_car_segments' do
    pending
  end

  describe '#get_car_segment' do
    pending
  end

  describe '#create_car_segments' do
    pending
  end

  describe '#update_car_segments' do
    pending
  end

  describe '#delete_car_segments' do
    pending
  end
end