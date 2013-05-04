$:.unshift File.expand_path('../lib', __FILE__)
require 'hypa/version'

Gem::Specification.new do |s|
  s.name                  = "hypa"
  s.version               = Hypa::VERSION
  s.author                = "Nicolas Mérouze"
  s.email                 = "nicolas@merouze.me"
  s.homepage              = "https://github.com/nmerouze/hypa"
  s.summary               = %q{Web Framework to make Hypermedia APIs}
  s.description           = s.summary
  s.license               = 'MIT'
  s.files                 = `git ls-files`.split("\n")
  s.test_files            = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables           = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files      = %w[README.md]
  s.require_path          = 'lib'
  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'extlib'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'coveralls'
end