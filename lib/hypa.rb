# encoding: utf-8
require 'bundler/setup'
require 'extlib/class'

module Hypa
  class Attribute
    attr_reader :name, :type

    def initialize(properties = {})
      @name = properties.delete(:name)
      @type = properties.delete(:type)
    end

    def to_hash
      { name: @name.to_s, type: @type.to_s }
    end
  end

  class AttributeSet
    attr_reader :attributes

    def initialize(&block)
      @attributes = []
      block.call(self) if block_given?
    end

    def attribute(name, properties = {})
      @attributes << Attribute.new(properties.merge(name: name))
    end

    # def set(name, &block)
    #   @sets[name] << AttributeSet.new(&block)
    # end

    def to_hash
      @attributes.map { |a| a.to_hash }
    end
  end

  class Action
    def initialize(&block)
      block.call(self) if block_given?
    end

    def rel(value)
      @rel = value
    end

    def href(value)
      @href = value
    end

    def params(&block)
      @params = AttributeSet.new(&block)
    end

    def to_hash
      { rel: @rel.to_s, href: @href.to_s, params: @params.to_hash }
    end
  end

  class Collection
    def initialize(&block)
      @actions = []
      block.call(self) if block_given?
    end

    def schema(&block)
      @schema = AttributeSet.new(&block)
    end

    def action(&block)
      @actions << Action.new(&block)
    end

    def to_hash
      { schema: @schema.to_hash, actions: @actions.map { |a| a.to_hash } }
    end

    # TODO: Refactoring
    def render(data)
      attributes = @schema.attributes.map { |a| a.name }

      if data.is_a?(Array)
        items = data.map do |d|
          item = {}
          attributes.each { |a| item[a] = d[a] }
          item
        end
      else
        items = {}
        attributes.each { |a| items[a] = data[a] }
      end
      
      self.to_hash.merge(items: items)
    end
  end

  class Application
    cattr_reader :collections

    @@collections = {}

    def self.collection(name, &block)
      @@collections[name] = Collection.new(&block)
    end
  end
end