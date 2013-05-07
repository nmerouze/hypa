# encoding: utf-8
require 'bundler/setup'
# require 'simplecov'
# require 'coveralls'

# SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
#   SimpleCov::Formatter::HTMLFormatter,
#   Coveralls::SimpleCov::Formatter
# ]

# SimpleCov.start do
#   project_name 'hypa'
#   minimum_coverage 95

#   add_filter '/spec/'
#   add_filter '/vendor/'
#   add_group 'Library', 'lib'
# end

require File.expand_path('../../lib/hypa', __FILE__)