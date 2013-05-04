require 'bundler/setup'
require 'sinatra'
require 'sequel'
require 'multi_json'
require 'hypa'

DB = Sequel.sqlite

DB.create_table(:posts) do
  primary_key :id
  String :title
  String :body
end

class Post < Sequel::Model
end

Post.insert(title: 'First Title', body: 'This is the first post')

class Blog < Hypa::Application
end

Blog.collection :posts do |c|
  c.schema do |s|
    s.attribute :id, type: 'integer'
    s.attribute :title, type: 'string'
    s.attribute :body, type: 'string'
  end

  c.action do |a|
    a.rel :self
    a.href '/posts'

    a.params do |p|
      p.attribute :limit, type: 'integer'
      # p.set :title do |s|
      #   s.attribute :in, type: 'array'
      #   s.attribute :like, type: 'string'
      # end
    end
  end
end

before do
  content_type 'application/hypa+json'
end

include Sinatra

get '/posts' do
  template = Blog.collections[:posts]
  # parameters = template.actions[:self].filter(params)
  posts = Post.all#(parameters)
  MultiJson.dump(template.render(posts))
end