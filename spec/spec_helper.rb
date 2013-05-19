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

shared_examples 'defining actions' do
  before do
    @action = Hypa::Action.new
    Hypa::Action.stub(:new).and_return(@action)
    expect(subject.actions).to eq({})
  end

  it 'stores a get action' do
    subject.get(:self) {}
    expect(subject.actions).to eq({ :self => @action })
  end

  it 'stores a post action' do
    subject.post(:create) {}
    expect(subject.actions).to eq({ :create => @action })
  end

  it 'stores a patch action' do
    subject.patch(:update) {}
    expect(subject.actions).to eq({ :update => @action })
  end

  it 'stores a delete action' do
    subject.delete(:delete) {}
    expect(subject.actions).to eq({ :delete => @action })
  end
end

require File.expand_path('../../lib/hypa', __FILE__)