require 'helper'

class PostResource < Hypa::Resource
  attributes :title
end

class PostsCollection < Hypa::Collection
  actions :get, :post, :options
end

class MyApp < Sinatra::Base
  get '/posts' do
    PostsCollection.action(:get)
  end

  options '/posts' do
    PostsCollection.action(:options)
  end
end

describe Hypa::Collection do
  include Rack::Test::Methods

  def app
    MyApp
  end

  describe 'GET /posts' do
    it 'renders posts' do
      get '/posts'
      last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
    end
  end

  describe 'OPTIONS /posts' do
    it 'renders schema' do
      options '/posts'
      last_response.body.must_equal('{"attributes":{"title":"string"},"associations":{}}')
    end
  end
end