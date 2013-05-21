# encoding: utf-8
require 'bundler/setup'
require 'extlib/class'
require 'extlib/hash'
require 'extlib/module'
require 'extlib/string'

module Hypa
end

class Hypa::Resource
  class_inheritable_accessor :_attributes
  self._attributes = []
  class_inheritable_accessor :_actions
  self._actions = {}

  class << self

    def attributes(*attributes)
      self._attributes = attributes
    end

    def actions(*actions)
      actions.each do |action|
        self._actions[action] = self.find_const("#{action.to_s.camel_case}Action")
      end
    end

    def to_hash
      hash = { name: human_name }
      hash[:resources] = { human_name => {  attributes: self._attributes } } unless self._attributes.empty?
      hash[:actions] = {} unless self._actions.empty?
      self._actions.each { |k,v| hash[:actions][k] = v.to_hash }
      hash
    end

    def human_name
      self.name.split('::').last.snake_case.split('_')[0..-2].join('_').to_sym
    end

  end
end

class Hypa::Collection
  class_inheritable_accessor :_resource
  class_inheritable_accessor :_actions
  self._actions = {}

  class << self

    def resource(class_name)
      self._resource = self.find_const("#{class_name.to_s.camel_case}Resource")
    end

    def actions(*actions)
      actions.each do |action|
        self._actions[action] = self.find_const("#{action.to_s.camel_case}Action")
      end
    end

    def to_hash
      name = self.name.split('::').last.snake_case.split('_')[0..-2].join('_').to_sym

      hash = { name: name }
      hash.merge!(self._resource.to_hash.only(:resources)) if self._resource
      hash[:actions] = {} unless self._actions.empty?
      self._actions.each { |k,v| hash[:actions][k] = v.to_hash }
      hash
    end

  end
end

class Hypa::Template
  def initialize(hash)
    @hash = hash
  end

  def render
    to_hash
  end

  def to_hash
    @hash
  end
end

class Hypa::ResourceTemplate
  def initialize(resource)
    @resource = resource
  end

  def render(data)
    data.map { |item| item.only(*@resource._attributes) }
  end

  def to_hash
    ref = "#/resources/#{@resource.human_name}"
    { type: 'array', items: { '$ref' => ref } }
  end
end

class Hypa::CollectionTemplate
  def initialize(collection)
    @collection = collection
  end

  def render(data)
    data.map { |item| item.only(*@collection._resource._attributes) }
  end

  def to_hash
    ref = "#/resources/#{@collection._resource.human_name}"
    { type: 'array', items: { '$ref' => ref } }
  end
end

class Hypa::Action
  class_inheritable_accessor :_name
  class_inheritable_accessor :_method
  class_inheritable_accessor :_href
  class_inheritable_accessor :_parameters
  self._parameters = []
  class_inheritable_accessor :_responses
  self._responses = {}

  class << self

    def get(options)
      name, href = *options.to_a.first

      self._method = 'GET'
      self._name = name
      self._href = href
    end

    def params(*parameters)
      self._parameters = parameters
    end

    def response(status, template)
      self._responses[status] = template.is_a?(Hash) ? Hypa::Template.new(template) : template
    end

    def to_hash
      hash = {}
      hash[:name] = self._name if self._name
      hash[:method] = self._method if self._method
      hash[:href] = self._href if self._href
      hash[:params] = self._parameters unless self._parameters.empty?
      hash[:responses] = {} unless self._responses.empty?
      self._responses.each { |k,v| hash[:responses][k] = v.to_hash }
      hash
    end

  end
end