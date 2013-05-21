# encoding: utf-8
require 'bundler/setup'
require 'extlib/class'
require 'extlib/hash'
require 'extlib/module'
require 'extlib/string'

# TODO: responses/templates

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
      name = self.name.snake_case.split('_')[0..-2].join('_').to_sym

      hash = { name: name }
      hash[:resources] = { name => {  attributes: self._attributes } } unless self._attributes.empty?
      hash[:actions] = {} unless self._actions.empty?
      self._actions.each { |k,v| hash[:actions][k] = v.to_hash }
      hash
    end

  end
end

class Hypa::Collection
  class_inheritable_accessor :_resource
  class_inheritable_accessor :_actions
  self._actions = {}

  class << self

    def resource(class_name)
      self._resource = Object.find_const("#{class_name.to_s.camel_case}Resource")
    end

    def actions(*actions)
      actions.each do |action|
        self._actions[action] = self.find_const("#{action.to_s.camel_case}Action")
      end
    end

    def to_hash
      name = self.name.snake_case.split('_')[0..-2].join('_').to_sym

      hash = { name: name }
      hash.merge!(self._resource.to_hash.only(:resources)) if self._resource
      hash[:actions] = {} unless self._actions.empty?
      self._actions.each { |k,v| hash[:actions][k] = v.to_hash }
      hash
    end

  end
end

class Hypa::Template

end

class Hypa::Action
  class_inheritable_accessor :_name
  class_inheritable_accessor :_method
  class_inheritable_accessor :_href
  class_inheritable_accessor :_parameters
  self._parameters = []
  # class_inheritable_accessor :_responses
  # self._responses = {}

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

    # def response(status, &block)
    #   self._responses[status] = block
    # end

    def to_hash
      hash = {}
      hash[:name] = self._name if self._name
      hash[:method] = self._method if self._method
      hash[:href] = self._href if self._href
      # hash[:responses] = self._responses unless self._responses.empty?
      hash[:params] = self._parameters unless self._parameters.empty?
      hash
    end

  end
end