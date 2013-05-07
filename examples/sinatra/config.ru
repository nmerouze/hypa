require 'bundler/setup'
require 'sinatra'
require 'sequel'
require 'hypa'
require 'multi_json'

class Blog
  cattr_reader :collections

  @@collections = {}

  def self.collection(name, &block)
    @@collections[name] = Hypa::Collection.new(name, &block)
  end
end

DB = Sequel.sqlite

DB.create_table :posts do
  primary_key :id
  String :title
end

DB.from(:posts).insert(title: 'HypaMedia')

class Post < Sequel::Model
end

Blog.collection :posts do |c|
  c.href '/posts'
  c.methods get: :self, post: :create

  c.resource do |r|
    r.href '/posts/{id}'
    r.methods get: :self, patch: :update, delete: :destroy

    r.integer :id
    r.string :title
  end

  c.action :self do |a|
    a.integer :limit
    a.array :title_in
  end

  c.action :create do |a|
    a.string :title, required: true
  end
end

before do
  content_type 'application/vnd.hypa+json'
end

get '/posts' do
  template = Blog.collections[:posts]
  posts = Post.all
  MultiJson.dump(template.render(posts))
end

run Sinatra::Application