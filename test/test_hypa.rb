require 'helper'

class PostSerializer < ActiveModel::Serializer
  attributes :title
end

class PostsCollection < Hypa::Collection
  actions :get, :post, :options

  query { Post.all }
end

class Post < ActiveRecord::Base
  def active_model_serializer
    PostSerializer
  end
end

Post.create(title: 'Foobar')

class MyApp < Sinatra::Base
  get '/posts' do
    PostsCollection.action(:get)
  end
end

describe Hypa::Collection do
  include Rack::Test::Methods

  def app
    MyApp
  end

  it 'renders get action' do
    get '/posts'
    last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
  end
end