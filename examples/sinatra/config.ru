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
end

class MyApp::PostResource < Hypa::Resource
  attributes :id, :title
  actions :self

  class SelfAction < Hypa::Action
    get :self => '/posts/:id'
  end
end

class MyApp::PostsCollection < Hypa::Collection
  resource :post
  actions :self

  class SelfAction < Hypa::Action
    get :self => '/posts'
  end
end

run MyApp