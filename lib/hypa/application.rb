require 'sinatra/base'
require 'multi_json'
require 'extlib/class'

class Hypa::Application < Sinatra::Base
  cattr_accessor :resources
  self.resources = {}

  before do
    content_type :json
  end

  def self.resource(name, path, &block)
    self.resources[name] = Hypa::Resource.new(name: :post, href: path, &block)

    route 'OPTIONS', path, {} do
      MultiJson.dump(self.resources[name].to_hash, mode: :compat)
    end

    self.resources[name]
  end
end