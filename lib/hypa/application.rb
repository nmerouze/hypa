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
    collection = self.collections[name] = Hypa::Collection.new(name: name, href: path, &block)

    route 'OPTIONS', path, {} do
      JSON.dump(collection.to_hash)
    end

    collection.actions.each do |action_name, action|
      route action.method, path, {} do
        data = collection.resource.model.all # TODO: Just for GET routes, with filter depending on params
        JSON.dump(name => action.responses[200].render(data.map(&:values)))
      end
    end

    self.collections[name]
  end
end