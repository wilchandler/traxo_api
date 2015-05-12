require 'spec_helper'

describe Traxo::BaseModel do

  class Foo < described_class

    attr_accessor :bar
    attr_accessor :baz

    def initialize
      args = {'no_foo_for_you' => 'foo', 'bar' => 'bar', 'baz' => 'baz'}
      attrs = [:bar, :baz]
      super(args, attrs)
    end
  end

  let(:foo) { Foo.new }

  it 'assigns to an array of attributes from a hash of properties' do
    expect(foo.bar).to eq 'bar'
    expect(foo.baz).to eq 'baz'
  end

  it 'does not assign to properties that are not specified' do
    expect{ foo.no_foo_for_you }.to raise_error
  end

end