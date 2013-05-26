require 'helper'

class PostResource < Hypa::Resource
  attributes :title
  actions :get, :delete
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

  delete '/posts/:id' do
    PostResource.action(:delete, params)
  end
end

describe Hypa::Resource do
  include Rack::Test::Methods

  def app; MyApp; end

  describe 'GET /posts/:id' do
    it 'renders a post' do
      get "/posts/#{@post.id}"
      last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
    end
  end

  describe 'DELETE /posts/:id' do
    it 'deletes a post' do
      delete "/posts/#{@post.id}"
      Post.find_by_id(@post.id).must_equal nil
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