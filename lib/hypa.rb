# encoding: utf-8
require 'bundler/setup'
require 'virtus'
# require 'extlib/class'

# TODO: Define template and default templates (Resource, Collection, NotFound, etc)
# TODO: Serialization of resource and collection
# TODO: get, post, patch, delete actions for resources and collections

module Hypa
end

class Hypa::Template
end

class Hypa::Response
  include Virtus
  attribute :status, Integer
  attribute :template, Hypa::Template
end

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
end

module Hypa::Actions
  include Virtus
  attribute :actions, Array[Hypa::Action]

  def get(name, &block)
    self.actions << Hypa::Action.new(name: name, method: 'GET', &block)
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
end