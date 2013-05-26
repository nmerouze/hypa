source 'https://rubygems.org'

gemspec

gem 'sinatra'
gem 'rack-test'
gem 'activesupport', '~> 3.2.0'
gem 'activerecord', '~> 3.2.0'

if defined?(JRUBY_VERSION)
  gem 'jdbc-sqlite3'
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
else
  gem 'sqlite3'
end

gem 'active_model_serializers', '~> 0.8.0'