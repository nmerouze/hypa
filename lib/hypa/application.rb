require 'sinatra/base'
require 'json'
require 'extlib/class'

class Hypa::Application < Sinatra::Base
  class_inheritable_accessor :resources
  self.resources = {}

  before do
    content_type :json
  end

  def self.resource(name, path, &block)
    self.resources[name] = Hypa::Resource.new(name: :post, href: path, &block)

    route 'OPTIONS', path, {} do
      JSON.dump(self.resources[name].to_hash)
    end

    self.resources[name]
  end
end