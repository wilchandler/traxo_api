$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'traxo_api'
require 'webmock/rspec'

FIXTURES_DIR = File.expand_path "#{File.dirname(__FILE__)}/fixtures"

RSpec::Matchers.define :have_attr_accessor do |field|
  match do |instance|
    instance.respond_to?(field) && instance.respond_to?("#{field}=")
  end

  failure_message do |object_instance|
    "expected attr_accessor for #{field} on #{object_instance}"
  end

  failure_message_when_negated do |object_instance|
    "expected attr_accessor for #{field} not to be defined on #{object_instance}"
  end

  description do
    "have an attr_accessor for its property :#{field}"
  end
end

RSpec::Matchers.define :have_attr_reader do |field|
  match do |instance|
    instance.respond_to?(field)
  end

  failure_message do |object_instance|
    "expected attr_reader for #{field} on #{object_instance}"
  end

  failure_message_when_negated do |object_instance|
    "expected attr_reader for #{field} not to be defined on #{object_instance}"
  end

  description do
    "have an attr_reader for its property :#{field}"
  end
end