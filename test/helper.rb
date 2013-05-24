# encoding: utf-8
require 'bundler/setup'
require 'minitest/autorun'
require 'rack/test'
require 'hypa'
require 'sinatra'
require 'active_record'
require 'active_model/serializer'

# require 'simplecov'
# require 'coveralls'

# SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
#   SimpleCov::Formatter::HTMLFormatter,
#   Coveralls::SimpleCov::Formatter
# ]

# SimpleCov.start do
#   project_name 'hypa'
#   minimum_coverage 80

#   add_filter '/spec/'
#   add_filter '/vendor/'
#   add_group 'Library', 'lib'
# end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database  => ':memory:')

# ActiveRecord::Migration.create_table :posts do |t|
#   t.string :title
# end

ActiveRecord::Schema.define do

  create_table :posts do |t|
    t.string :title
  end

end