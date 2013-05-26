require 'helper'

class PostResource < Hypa::Resource
  attributes :title
  actions :get
end

class PostsCollection < Hypa::Collection
  actions :get
end

class MyApp < Sinatra::Base
  get '/posts' do
    PostsCollection.action(:get)
  end

  get '/posts/:id' do
    PostResource.action(:get, params)
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
end