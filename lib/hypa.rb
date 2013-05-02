require 'bundler/setup'
require 'virtus'
require 'sinatra'
require 'oj' # TODO: Use multi_json
require 'addressable/template'
require 'extlib/class'
require 'extlib/inflection'

module Hypa
  class Attribute
    include Virtus

    attribute :name, String
    attribute :value, String
    attribute :prompt, String
  end

  class Link
    include Virtus

    attribute :rel, String
    attribute :href, String
  end

  class Item
    include Virtus

    attribute :href, String
    attribute :data, Array[Attribute]
    attribute :links, Array[Link]

    def render(data)
      self.href = Addressable::Template.new(self.href).expand(data)
      # FIX: value should not be URL escaped
      self.data.each { |a| a.value = Addressable::Template.new(a.value).expand(data) }
      self
    end
  end

  class Template
    include Virtus

    attribute :data, Array[Attribute]
  end

  class Query
    include Virtus

    attribute :data, Array[Attribute]
    attribute :rel, String
    attribute :href, String
    attribute :prompt, String
  end

  class Collection
    include Virtus

    attribute :version, String
    attribute :href, String
    attribute :links, Array[Link]
    attribute :items, Array[Item]
    attribute :template, Template
    attribute :queries, Array[Query]
  end

  class Application < Sinatra::Base
    cattr_accessor :templates, :collections, :items

    set :show_exceptions, false

    before do
      content_type 'application/vnd.collection+json'
    end

    get '/:collection' do
      coll_name = params[:collection].to_sym

      if collection = @@collections[coll_name]
        items = DB.from(coll_name).all

        collection.items = items.map do |data|
          @@items[coll_name.to_s.singular.to_sym].clone.render(data)
        end

        Oj.dump(collection.to_hash, mode: :compat)
      else
        status 404
        Oj.dump({ error: 'Not found.' }, mode: :compat)
      end
    end

    get '/:collection/:id' do
    end

    post '/:collection' do
    end

    patch '/:collection/:id' do
    end

    delete '/:collection/:id' do
    end

    class << self
      def template(name, &block)
        @@templates ||= {}

        if block_given?
          template = Template.new
          block.call(template)
          @@templates[name] = template
        else
          template = @@templates[name]
        end

        template
      end

      def collection(name, &block)
        @@collections ||= {}

        if block_given?
          collection = Collection.new
          block.call(collection)
          @@collections[name] = collection
        else
          collection = @@collections[name]
        end

        collection
      end

      def item(name, &block)
        @@items ||= {}

        if block_given?
          item = Item.new
          block.call(item)
          @@items[name] = item
        else
          item = @@items[name]
        end

        item
      end
    end
  end
end