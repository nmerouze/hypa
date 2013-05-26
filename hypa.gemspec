# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hypa/version'

Gem::Specification.new do |spec|
  spec.name          = "hypa"
  spec.version       = Hypa::VERSION
  spec.authors       = ["Nicolas Mérouze"]
  spec.email         = ["nicolas@merouze.me"]
  spec.description   = %q{Web Framework to make Hypermedia APIs}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/nmerouze/hypa"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_runtime_dependency 'active_model_serializers', '~> 0.8.0'

  spec.add_development_dependency 'activerecord', '~> 3.2.0'
  spec.add_development_dependency 'sinatra'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
end