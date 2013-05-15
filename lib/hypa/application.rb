require 'sinatra/base'
require 'json'
require 'extlib/class'

class Hypa::Application < Sinatra::Base
  class_inheritable_accessor :resources
  self.resources = {}
  class_inheritable_accessor :collections
  self.collections = {}

  before do
    content_type :json
  end

  def self.resource(name, path, &block)
    self.resources[name] = Hypa::Resource.new(name: name, href: path, &block)

    route 'OPTIONS', path, {} do
      JSON.dump(self.resources[name].to_hash)
    end

    self.resources[name]
  end

  def self.collection(name, path, &block)
    self.collections[name] = Hypa::Collection.new(name: :post, href: path, &block)

    route 'OPTIONS', path, {} do
      JSON.dump(self.collections[name].to_hash)
    end

    self.collections[name]
  end
end