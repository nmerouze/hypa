# encoding: utf-8
require 'bundler/setup'
require 'virtus'
require 'extlib/class'

class Hypa::Action
  include Virtus

  class Param
    include Virtus

    attribute :name, String
    attribute :type, String
  end

  attribute :rel, Symbol
  attribute :href, String
  attribute :method, Symbol
  attribute :params, Array[Param]

  def initialize(&block)
    block.call(DSL.new(self)) if block_given?
  end

  class DSL
    def initialize(action)
      @action = action
    end

    def href(href)
      @action.href = href
    end

    def method(method)
      @action.method = method
    end

    def integer(name, options = {})
      self.param(name, options.merge(type: 'integer'))
    end

    def string(name, options = {})
      self.param(name, options.merge(type: 'string'))
    end

    def array(name, options = {})
      self.param(name, options.merge(type: 'array'))
    end

    def param(name, options = {})
      @action.params << Param.new(options.merge(name: name))
    end
  end
end

class Hypa::Resource
  include Virtus

  class Property
    include Virtus

    attribute :name, String
    attribute :type, String
  end

  attribute :href, String
  attribute :methods, Hash[Symbol => Symbol]
  attribute :properties, Array[Property]
  attribute :actions, Hash[Symbol => Hypa::Action]

  def initialize(&block)
    block.call(DSL.new(self)) if block_given?
  end

  def attributes
    self.methods.each do |method, action_name|
      action = self.actions[action_name]
      self.actions[action_name] = action = Hypa::Action.new unless action
      action.method = method
      action.href = self.href
    end

    actions = self.actions.map do |rel, action|
      { rel: rel, method: action.method, href: action.href, params: action.params.map { |p| p.attributes } }
    end

    { properties: properties.map { |p| p.attributes }, actions: actions }
  end

  class DSL
    def initialize(resource)
      @resource = resource
    end

    def href(href)
      @resource.href = href
    end

    def methods(methods = {})
      @resource.methods = methods
    end

    def action(name, &block)
      @resource.actions[name] = Hypa::Action.new(&block)
    end

    def integer(name, options = {})
      self.property(name, options.merge(type: 'integer'))
    end

    def string(name, options = {})
      self.property(name, options.merge(type: 'string'))
    end

    def array(name, options = {})
      self.property(name, options.merge(type: 'array'))
    end

    def property(name, options = {})
      @resource.properties << Property.new(options.merge(name: name))
    end
  end
end

class Hypa::Collection
  include Virtus

  attribute :href, String
  attribute :methods, Hash[Symbol => Symbol]
  attribute :actions, Hash[Symbol => Hypa::Action]
  attribute :resource, Hypa::Resource

  def initialize(&block)
    block.call(DSL.new(self)) if block_given?
  end

  def attributes
    self.methods.each do |method, action_name|
      if action = self.actions[action_name]
        action.method = method
        action.href = self.href
      end
    end

    actions = self.actions.map do |rel, action|
      { rel: rel, method: action.method, href: action.href, params: action.params.map { |p| p.attributes } }
    end

    { resource: self.resource.attributes, actions: actions }
  end

  def render(model)
    Hypa::Application.new(self, model)    
  end

  class DSL
    def initialize(collection)
      @collection = collection
    end

    def href(href)
      @collection.href = href
    end

    def methods(methods = {})
      @collection.methods = methods
    end

    def resource(&block)
      @collection.resource = Hypa::Resource.new(&block)
    end

    def action(name, &block)
      @collection.actions[name] = Hypa::Action.new(&block)
    end
  end
end