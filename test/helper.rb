# encoding: utf-8
require 'bundler/setup'
require 'minitest/autorun'
require 'rack/test'
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  project_name 'hypa'
  # minimum_coverage 80

  add_filter '/test/'
  add_filter '/vendor/'
  add_group 'Library', 'lib'
  command_name 'Unit Tests'
end

require 'hypa'
require 'sinatra/base'
require 'active_record'
require 'fixtures'

ENV['RACK_ENV'] = 'test'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database  => ':memory:')

ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.string :title
  end
end

class MiniTest::Spec
  include Rack::Test::Methods
  def app; MyApp; end

  after { Post.delete_all }
end