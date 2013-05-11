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

Blog.collection :posts do
  href '/posts'
  methods get: :self, post: :create

  resource do
    href '/posts/{id}'
    methods get: :self, patch: :update, delete: :destroy

    integer :id
    string :title
  end

  action :self do
    integer :limit
    array :title_in
  end

  action :create do
    string :title, required: true
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