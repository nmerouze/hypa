require 'bundler/setup'
require 'hypa'
require 'sequel'

DB = Sequel.sqlite

DB.create_table :posts do
  primary_key :id
  String :title
end

DB.from(:posts).insert(title: 'HypaMedia')

class Post < Sequel::Model
end

Hypa::Application.resource :post, '/posts/:id' do |r|
  r.properties :id, :title
  r.model Post

  r.get :self do |a|
    a.params :id
    a.response 200, Hypa::ResourceTemplate.new(r)
  end
end

Hypa::Application.collection :posts, '/posts' do |c|
  c.resource Hypa::Application.resources[:post]

  c.get :self do |a|
    a.response 200, Hypa::CollectionTemplate.new(c)
  end
end

run Hypa::Application