$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'traxo'
require 'webmock/rspec'

FIXTURES_DIR = File.expand_path "#{File.dirname(__FILE__)}/fixtures"