require 'bundler/setup'
require 'hypa'
require 'sinatra/base'
require 'json'
# require 'sequel'

# DB = Sequel.sqlite

# DB.create_table :posts do
#   primary_key :id
#   String :title
# end

# DB.from(:posts).insert(title: 'HypaMedia')

# class Post < Sequel::Model
# end

class MyApp < Sinatra::Base
  options '/posts' do
    JSON.dump(PostsCollection.to_hash)
  end

  options '/posts/:id' do
    JSON.dump(PostResource.to_hash)
  end
end

class MyApp::PostResource < Hypa::Resource
  class SelfAction < Hypa::Action
    get :self => '/posts/:id'

    response 200, type: 'array', items: { '$ref' => '#/resources/post' }
    response 404, status: 'Not found', message: 'This post is missing.'
  end

  attributes :id, :title
  actions :self
end

class MyApp::PostsCollection < Hypa::Collection
  class SelfAction < Hypa::Action
    get :self => '/posts'

    response 200, type: 'array', items: { '$ref' => '#/resources/post' }
  end

  resource :post
  actions :self
end

run MyApp