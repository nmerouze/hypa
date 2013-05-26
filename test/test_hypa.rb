require 'helper'

class PostResource < Hypa::Resource
  attributes :title
  actions :get, :options
end

class PostsCollection < Hypa::Collection
  actions :get, :options
end

class MyApp < Sinatra::Base
  get '/posts' do
    PostsCollection.action(:get)
  end

  options '/posts' do
    PostsCollection.action(:options)
  end

  get '/posts/:id' do
    PostResource.action(:get, params)
  end

  options '/posts/:id' do
    PostResource.action(:options)
  end
end

describe Hypa::Resource do
  include Rack::Test::Methods

  def app; MyApp; end

  describe 'GET /posts/:id' do
    it 'renders a post' do
      get '/posts/1'
      last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
    end
  end

  describe 'OPTIONS /posts/:id' do
    it 'renders post schema' do
      options '/posts/1'
      last_response.body.must_equal('{"attributes":{"title":"string"},"associations":{}}')
    end
  end
end

describe Hypa::Collection do
  include Rack::Test::Methods

  def app; MyApp; end

  describe 'GET /posts' do
    it 'renders posts' do
      get '/posts'
      last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
    end
  end

  describe 'OPTIONS /posts' do
    it 'renders post schema' do
      options '/posts'
      last_response.body.must_equal('{"attributes":{"title":"string"},"associations":{}}')
    end
  end
end