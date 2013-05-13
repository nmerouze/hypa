# encoding: utf-8
require 'bundler/setup'
require 'virtus'
# require 'extlib/class'

# TODO: Define template and default templates (Resource, Collection, NotFound, etc)

module Hypa
end

class Hypa::Template
  def to_hash
    {}
  end
end

class Hypa::ResourceTemplate < Hypa::Template
end

class Hypa::CollectionTemplate < Hypa::Template
end

require_relative 'hypa/response'

class Hypa::Action
  include Virtus
  attribute :name, Symbol
  attribute :method, String
  attribute :_parameters, Array, writer: :private, default: [] # FIX: accessor: :private doesn't work
  attribute :responses, Array[Hypa::Response]

  def initialize(attributes = {}, &block)
    super(attributes)
    instance_eval(&block) if block_given?
  end

  def params(*params)
    params.empty? ? self._parameters : self._parameters = params
  end

  def response(status, template)
    self.responses << Hypa::Response.new(status: 200, template: template)
  end

  def to_hash
    { name: self.name, method: self.method, params: self._parameters, responses: responses.map { |r| r.to_hash } }
  end
end

module Hypa::Actions
  include Virtus
  attribute :actions, Array[Hypa::Action]

  def get(name, &block)
    action(name, 'GET', &block)
  end

  def post(name, &block)
    action(name, 'POST', &block)
  end

  def patch(name, &block)
    action(name, 'PATCH', &block)
  end

  def delete(name, &block)
    action(name, 'DELETE', &block)
  end

  private

  def action(name, method, &block)
    self.actions << Hypa::Action.new(name: name, method: method, &block)
  end
end

class Hypa::Resource
  include Virtus
  include Hypa::Actions

  attribute :_properties, Array, writer: :private, default: []

  def initialize(&block)
    instance_eval(&block) if block_given?
  end

  def properties(*properties)
    properties.empty? ? self._properties : self._properties = properties
  end

  def to_hash
    { properties: self._properties, actions: actions.map { |a| a.to_hash } }
  end
end

class Hypa::Collection
  include Virtus
  include Hypa::Actions

  attribute :_resource, Hypa::Resource, writer: :private

  def initialize(&block)
    instance_eval(&block) if block_given?
  end

  def resource(resource = nil)
    resource.nil? ? self._resource : self._resource = resource
  end

  def to_hash
    { resource: (self.resource ? self.resource.to_hash : nil), actions: actions.map { |a| a.to_hash } }
  end
end