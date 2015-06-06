# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'traxo/version'

Gem::Specification.new do |spec|
  spec.name          = "traxo_api"
  spec.version       = Traxo::VERSION
  spec.authors       = ["Wil Chandler"]
  spec.email         = ["wilchandler2@gmail.com"]

  spec.summary       = %q{Ruby interface for interacting with the Traxo API}
  spec.description   = %q{The traxo_api gem provides both 'authentication' and 'client' modules to simplify the process of gaining a user's authentication and making CRUD requests to the Traxo API on their behalf.}
  spec.homepage      = "https://github.com/wilchandler/traxo_api"
  spec.license       = "MIT"

  # # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'webmock', '~> 1.21'
  spec.add_development_dependency 'pry'
end
