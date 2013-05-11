# encoding: utf-8
require 'bundler/setup'
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  project_name 'hypa'
  minimum_coverage 80

  add_filter '/spec/'
  add_filter '/vendor/'
  add_group 'Library', 'lib'
end

RSpec.configure do |c|
  c.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'
end

require File.expand_path('../../lib/hypa', __FILE__)