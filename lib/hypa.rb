require 'active_support/all'
require 'action_controller'
require 'sequel'
require 'json'
require 'uri_template'

class Hypa
  cattr_accessor :connection

  def self.migrate!
    Hypa::Resource.descendants.each do |resource|
      Hypa.connection.create_table!(resource.table_name) do
        resource.properties.each { |name, options| column name, options.delete(:type), options.slice(:primary_key) }
      end
    end
  end

  def self.app
    router = ActionDispatch::Routing::RouteSet.new

    router.draw do
      Hypa::Resource.descendants.each do |resource|
        resource.actions.each do |action_name, action_options|
          match URITemplate.new(action_options.last).expand(resource_name: resource.table_name), to: resource.action(action_name), via: action_options.first
        end
      end
    end

    router
  end

  class Controller < ActionController::Metal
    def show
      record = Hypa.connection.from(controller_name).filter(id: params[:id]).first
      self.content_type = 'application/json'
      self.status = 200
      self.response_body = represent(record)
    end

    def create
      params[:id] = Hypa.connection.from(controller_name).insert(params)
      show
      self.status = 201
    end

    private

    def resource
      @resource ||= self.class.name.demodulize.sub(/Controller$/, 'Resource').constantize
    end

    def represent(data)
      hash = {}
      resource.properties.each { |n, o| hash[o[:key]] = data[n] }
      JSON.generate(controller_name => [hash])
    end
  end

  class Resource
    class_attribute :properties
    self.properties = {}

    class_attribute :actions
    self.actions = {
      index: [:get, '/{resource_name}'],
      create: [:post, '/{resource_name}'],
      show: [:get, '/{resource_name}/:id'],
      update: [:patch, '/{resource_name}/:id'],
      destroy: [:delete, '/{resource_name}/:id']
    }

    # Model/Serialization related

    def self.table_name
      self.name.sub(/Resource$/, '').underscore
    end

    def self.primary_key(name, key: name)
      self.property(name, type: 'integer', key: key, primary_key: true)
    end

    def self.string(name, key: name)
      self.property(name, type: 'string', key: key)
    end

    def self.property(name, type: 'string', key: name, **options)
      self.properties[name] = { type: type, key: key }.merge(options)
    end

    # Controller related

    def self.controller
      @controller ||= self.const_set(self.name.sub(/Resource$/, 'Controller'), Class.new(Controller))
    end

    def self.action(name)
      self.controller.action(name)
    end
  end
end